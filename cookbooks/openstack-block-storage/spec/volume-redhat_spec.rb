# encoding: UTF-8
#
# Cookbook Name:: openstack-block-storage

require_relative 'spec_helper'

describe 'openstack-block-storage::volume' do
  describe 'redhat' do
    let(:runner) { ChefSpec::Runner.new(REDHAT_OPTS) }
    let(:node) { runner.node }
    let(:chef_run) { runner.converge(described_recipe) }

    include_context 'block-storage-stubs'

    it 'installs mysql python packages by default' do
      expect(chef_run).to upgrade_package('MySQL-python')
    end

    it 'installs db2 python packages if explicitly told' do
      node.set['openstack']['db']['block-storage']['service_type'] = 'db2'

      ['python-ibm-db', 'python-ibm-db-sa'].each do |pkg|
        expect(chef_run).to upgrade_package(pkg)
      end
    end

    it 'installs postgresql python packages if explicitly told' do
      node.set['openstack']['db']['block-storage']['service_type'] = 'postgresql'

      expect(chef_run).to upgrade_package('python-psycopg2')
      expect(chef_run).not_to upgrade_package('MySQL-python')
    end

    it 'installs cinder iscsi packages' do
      expect(chef_run).to upgrade_package('scsi-target-utils')
    end

    it 'starts cinder volume' do
      expect(chef_run).to start_service('openstack-cinder-volume')
    end

    it 'starts cinder volume on boot' do
      expect(chef_run).to enable_service('openstack-cinder-volume')
    end

    context 'ISCSI' do
      let(:file) { chef_run.template('/etc/tgt/targets.conf') }
      it 'starts iscsi target on boot' do
        expect(chef_run).to enable_service('tgtd')
      end

      it 'has redhat include' do
        expect(chef_run).to render_file(file.name).with_content(
          'include /var/lib/cinder/volumes/*')
        expect(chef_run).not_to render_file(file.name).with_content(
          'include /etc/tgt/conf.d/*.conf')
      end
    end

    context 'NFS Driver' do
      before do
        node.set['openstack']['block-storage']['volume']['driver'] = 'cinder.volume.drivers.netapp.nfs.NetAppDirect7modeNfsDriver'
      end

      it 'installs nfs packages' do
        expect(chef_run).to upgrade_package('nfs-utils')
        expect(chef_run).to upgrade_package('nfs-utils-lib')
      end
    end

    context 'EMC ISCSI Driver' do
      before do
        node.set['openstack']['block-storage']['volume']['driver'] = 'cinder.volume.drivers.emc.emc_smis_iscsi.EMCSMISISCSIDriver'
      end

      it 'installs emc packages' do
        expect(chef_run).to upgrade_package('pywbem')
      end
    end

    describe 'IBM GPFS volume driver' do
      before do
        @chef_run = ::ChefSpec::Runner.new ::REDHAT_OPTS do |n|
          n.set['openstack']['block-storage']['volume']['driver'] = 'cinder.volume.drivers.gpfs.GPFSDriver'
          n.set['openstack']['block-storage']['gpfs']['gpfs_mount_point_base'] = 'volumes'
        end

        @conf = '/etc/cinder/cinder.conf'
        @chef_run.converge 'openstack-block-storage::volume'
      end

      it 'verifies gpfs_mount_point_base' do
        expect(@chef_run).to render_file(@conf).with_content(
          /^gpfs_mount_point_base = volumes$/)
      end

      it 'verifies gpfs_images_dir' do
        @chef_run.node.set['openstack']['block-storage']['gpfs']['gpfs_images_dir'] = 'images'
        expect(@chef_run).to render_file(@conf).with_content(
          /^gpfs_images_dir = images$/)
      end

      it 'verifies gpfs_images_share_mode is default' do
        expect(@chef_run).to render_file(@conf).with_content(
          /^gpfs_images_share_mode = copy_on_write$/)
      end

      it 'verifies gpfs_sparse_volumes is default' do
        expect(@chef_run).to render_file(@conf).with_content(
          /^gpfs_sparse_volumes = true$/)
      end

      it 'verifies gpfs_max_clone_depth is default' do
        expect(@chef_run).to render_file(@conf).with_content(
          /^gpfs_max_clone_depth = 8$/)
      end

      it 'verifies gpfs_storage_pool is default' do
        expect(@chef_run).to render_file(@conf).with_content(
          /^gpfs_storage_pool = system$/)
      end

      it 'verifies gpfs volume directory is created with owner and mode set correctly' do
        expect(@chef_run).to create_directory('volumes').with(
           owner: 'cinder',
           group: 'cinder',
           mode: '0755'
        )
      end
    end
  end
end
