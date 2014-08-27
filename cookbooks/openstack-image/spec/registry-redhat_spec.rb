# encoding: UTF-8
require_relative 'spec_helper'

describe 'openstack-image::registry' do
  describe 'redhat' do
    let(:runner) { ChefSpec::Runner.new(REDHAT_OPTS) }
    let(:node) { runner.node }
    let(:chef_run) do
      runner.converge(described_recipe)
    end

    include_context 'image-stubs'

    it 'converges when configured to use sqlite' do
      node.set['openstack']['db']['image']['service_type'] = 'sqlite'

      expect { chef_run }.to_not raise_error
    end

    it 'installs mysql python packages' do
      expect(chef_run).to install_package('MySQL-python')
    end

    it 'installs db2 python packages if explicitly told' do
      node.set['openstack']['db']['image']['service_type'] = 'db2'

      ['python-ibm-db', 'python-ibm-db-sa'].each do |pkg|
        expect(chef_run).to install_package(pkg)
      end
    end

    it 'installs glance packages' do
      expect(chef_run).to upgrade_package('openstack-glance')
      expect(chef_run).to upgrade_package('cronie')
    end

    it 'starts glance registry on boot' do
      expect(chef_run).to enable_service('openstack-glance-registry')
    end

    it 'does not version the database' do
      stub_command('glance-manage db_version').and_return(false)
      cmd = 'glance-manage version_control 0'

      expect(chef_run).not_to run_execute(cmd)
    end
  end
end
