# encoding: UTF-8
require_relative 'spec_helper'

describe 'openstack-image::api' do
  describe 'ubuntu' do
    let(:runner) { ChefSpec::Runner.new(UBUNTU_OPTS) }
    let(:node) { runner.node }
    let(:chef_run) do
      runner.converge(described_recipe)
    end

    include_context 'image-stubs'
    include_examples 'common-logging-recipe'
    include_examples 'common-packages'
    include_examples 'cache-directory'
    include_examples 'glance-directory'

    it 'does not upgrade swift package by default' do
      expect(chef_run).not_to upgrade_package('python-swift')
    end

    describe 'using swift for default_store' do
      before do
        node.set['openstack']['image']['api']['default_store'] = 'swift'
      end

      it 'upgrades swift package if openstack/image/api/default_store is swift' do
        expect(chef_run).to upgrade_package('python-swift')
      end

      it 'honors platform package name and option overrides for swift packages' do
        node.set['openstack']['image']['platform']['package_overrides'] = '--override1 --override2'
        node.set['openstack']['image']['platform']['swift_packages'] = ['my-swift']

        expect(chef_run).to upgrade_package('my-swift').with(options: '--override1 --override2')
      end
    end

    describe 'using rbd for default_store' do
      before do
        node.set['openstack']['image']['api']['default_store'] = 'rbd'
      end

      it 'upgrades python-ceph package' do
        expect(chef_run).to upgrade_package('python-ceph')
      end

      it 'honors platform package name and option overrides for ceph packages' do
        node.set['openstack']['image']['platform']['package_overrides'] = '--override1 --override2'
        node.set['openstack']['image']['platform']['ceph_packages'] = ['my-ceph']

        expect(chef_run).to upgrade_package('my-ceph').with(options: '--override1 --override2')
      end

      it 'includes the ceph_client recipe from openstack-common' do
        expect(chef_run).to include_recipe('openstack-common::ceph_client')
      end

      describe 'cephx client keyring file' do
        let(:file) { chef_run.template('/etc/ceph/ceph.client.glance.keyring') }
        it 'has the proper content' do
          [/^\[client\.glance\]$/,
           /^  key = rbd-pass$/].each do |content|
            expect(chef_run).to render_file(file.name).with_content(content)
          end
        end

        it "is created using openstack-common's template" do
          expect(chef_run).to create_template(file.name).with(cookbook: 'openstack-common')
        end

        it 'has the correct owner' do
          expect(file.owner). to eq('glance')
          expect(file.group). to eq('glance')
        end

        it 'has the correct mode' do
          expect(sprintf('%o', file.mode)).to eq '600'
        end
      end
    end

    it 'starts glance api on boot' do
      expect(chef_run).to enable_service('glance-api')
    end

    describe 'policy.json' do
      let(:file) { chef_run.template('/etc/glance/policy.json') }

      it 'has proper owner' do
        expect(file.owner).to eq('glance')
        expect(file.group).to eq('glance')
      end

      it 'has proper modes' do
        expect(sprintf('%o', file.mode)).to eq '644'
      end

      it 'notifies glance-api restart' do
        expect(file).to notify('service[glance-api]').to(:restart)
      end
    end

    describe 'glance-api.conf' do
      let(:file) { chef_run.template('/etc/glance/glance-api.conf') }

      it 'has proper owner' do
        expect(file.owner).to eq('glance')
        expect(file.group).to eq('glance')
      end

      it 'has proper modes' do
        expect(sprintf('%o', file.mode)).to eq '644'
      end

      it 'has bind host when bind_interface not specified' do
        match = 'bind_host = 127.0.0.1'
        expect(chef_run).to render_file(file.name).with_content(match)
      end

      it 'has bind host when bind_interface specified' do
        node.set['openstack']['endpoints']['image-api-bind']['bind_interface'] = 'lo'

        match = 'bind_host = 127.0.1.1'
        expect(chef_run).to render_file(file.name).with_content(match)
      end

      it 'has default filesystem_store_datadir setting' do
        match = 'filesystem_store_datadir = /var/lib/glance/images'
        expect(chef_run).to render_file(file.name).with_content(match)
      end

      it 'has configurable filesystem_store_datadir setting' do
        node.set['openstack']['image']['filesystem_store_datadir'] = 'foo'

        expect(chef_run).to render_file(file.name).with_content(
          /^filesystem_store_datadir = foo$/)
      end

      it 'notifies glance-api restart' do
        expect(file).to notify('service[glance-api]').to(:restart)
      end

      it 'does not have caching enabled by default' do
        expect(chef_run).to render_file(file.name).with_content(
          /^flavor = keystone$/)
      end

      it 'enables caching when attribute is set' do
        node.set['openstack']['image']['api']['caching'] = true

        expect(chef_run).to render_file(file.name).with_content(
          /^flavor = keystone\+caching$/)
      end

      it 'enables cache_management when attribute is set' do
        node.set['openstack']['image']['api']['cache_management'] = true

        expect(chef_run).to render_file(file.name).with_content(
          /^flavor = keystone\+cachemanagement$/)
      end

      it 'enables only cache_management when it and the caching attributes are set' do
        node.set['openstack']['image']['api']['cache_management'] = true
        node.set['openstack']['image']['api']['caching'] = true

        expect(chef_run).to render_file(file.name).with_content(
          /^flavor = keystone\+cachemanagement$/)
      end

      it 'has configurable api workers setting' do
        node.set['openstack']['image']['api']['workers'] = 10
        expect(chef_run).to render_file(file.name).with_content(
          /^workers = 10$/)
      end

      it 'confirms default min value is set' do
        node.automatic['cpu']['total'] = 10
        expect(chef_run).to render_file(file.name).with_content(
          /^workers = 8$/)
      end

      it 'sets show_image_direct_url appropriately' do
        node.set['openstack']['image']['api']['show_image_direct_url'] = 'True'
        expect(chef_run).to render_file(file.name).with_content(
          /^show_image_direct_url = True$/)
      end

      it 'sets swift_enable_snet as specified' do
        node.set['openstack']['image']['api']['swift']['enable_snet'] = 'True'
        expect(chef_run).to render_file(file.name).with_content(
          /^swift_enable_snet = True$/)
      end

      it 'doesnt set swift_store_region if nil' do
        node.set['openstack']['image']['api']['swift']['store_region'] = nil
        expect(chef_run).to_not render_file(file.name).with_content(
          /^swift_store_region/)
      end

      it 'does set swift_store_region if not nil' do
        node.set['openstack']['image']['api']['swift']['store_region'] = 'test_region'
        expect(chef_run).to render_file(file.name).with_content(
          /^swift_store_region = test_region$/)
      end

      it 'does set the default rbd_store settings' do
        [%r|^rbd_store_ceph_conf = /etc/ceph/ceph\.conf$|,
         /^rbd_store_user = glance$/,
         /^rbd_store_pool = images$/,
         /^rbd_store_chunk_size = 8$/
        ].each do |line|
          expect(chef_run).to render_file(file.name).with_content(line)
        end
      end

      it 'does set the rbd_store settings when overridden' do
        node.set['openstack']['image']['api']['rbd']['rbd_store_ceph_conf'] = '/etc/ceph.conf'
        node.set['openstack']['image']['api']['rbd']['rbd_store_user'] = 'openstack-image'
        node.set['openstack']['image']['api']['rbd']['rbd_store_pool'] = 'bootimages'
        node.set['openstack']['image']['api']['rbd']['rbd_store_chunk_size'] = 4

        [%r|^rbd_store_ceph_conf = /etc/ceph\.conf$|,
         /^rbd_store_user = openstack-image$/,
         /^rbd_store_pool = bootimages$/,
         /^rbd_store_chunk_size = 4$/
        ].each do |line|
          expect(chef_run).to render_file(file.name).with_content(line)
        end
      end

      it 'has default_store setting' do
        expect(chef_run).to render_file(file.name).with_content(
          /^default_store = file$/)
      end

      [
        /^vmware_server_host = $/,
        /^vmware_server_username = $/,
        /^vmware_server_password = $/,
        /^vmware_datacenter_path = $/,
        /^vmware_datastore_name = $/,
        /^vmware_api_retry_count = 10/,
        /^vmware_task_poll_interval = 5$/,
        /^vmware_store_image_dir = \/openstack_glance$/,
        /^vmware_api_insecure = false$/
      ].each do |content|
        it "has a #{content.source[1...-1]} line" do
          expect(chef_run).to render_file(file.name).with_content(content)
        end
      end
    end

    describe 'keystone_authtoken' do
      let(:file) { chef_run.template('/etc/glance/glance-api.conf') }

      it 'has auth_uri' do
        expect(chef_run).to render_file(file.name).with_content(
          /^#{Regexp.quote('auth_uri = http://127.0.0.1:5000/v2.0')}$/)
      end

      it 'has auth_host' do
        expect(chef_run).to render_file(file.name).with_content(
          /^#{Regexp.quote('auth_host = 127.0.0.1')}$/)
      end

      it 'has auth_port' do
        expect(chef_run).to render_file(file.name).with_content(
          /^auth_port = 35357$/)
      end

      it 'has auth_protocol' do
        expect(chef_run).to render_file(file.name).with_content(
          /^auth_protocol = http$/)
      end

      it 'has no auth_version' do
        expect(chef_run).not_to render_file(file.name).with_content(
          /^auth_version = v2.0$/)
      end

      it 'has admin_tenant_name' do
        expect(chef_run).to render_file(file.name).with_content(
          /^admin_tenant_name = service$/)
      end

      it 'has admin_user' do
        expect(chef_run).to render_file(file.name).with_content(
          /^admin_user = glance$/)
      end

      it 'has admin_password' do
        expect(chef_run).to render_file(file.name).with_content(
          /^admin_password = glance-pass$/)
      end

      it 'has signing_dir' do
        expect(chef_run).to render_file(file.name).with_content(
          /^#{Regexp.quote('signing_dir = /var/cache/glance/api')}$/)
      end

      it 'has auth_version when auth version is set to v3.0' do
        chef_run.node.set['openstack']['image']['api']['auth']['version'] = 'v3.0'
        expect(chef_run).to render_file(file.name).with_content(
          /^auth_version = v3.0$/)
      end
    end

    describe 'rabbitmq' do
      let(:file) { chef_run.template('/etc/glance/glance-api.conf') }

      before do
        node.set['openstack']['image']['notification_driver'] = 'messaging'
        node.set['openstack']['mq']['image']['service_type'] = 'rabbitmq'
        node.set['openstack']['mq']['image']['notification_topic'] = 'rabbit_topic'
      end

      it 'has rabbit_host' do
        match = 'rabbit_host = 127.0.0.1'
        expect(chef_run).to render_file(file.name).with_content(match)
      end

      it 'has rabbit_port' do
        match = 'rabbit_port = 5672'
        expect(chef_run).to render_file(file.name).with_content(match)
      end

      it 'has rabbit_userid' do
        match = 'rabbit_userid = guest'
        expect(chef_run).to render_file(file.name).with_content(match)
      end

      it 'has rabbit_password' do
        match = 'rabbit_password = mq-pass'
        expect(chef_run).to render_file(file.name).with_content(match)
      end

      it 'has rabbit_virtual_host' do
        match = 'rabbit_virtual_host = /'
        expect(chef_run).to render_file(file.name).with_content(match)
      end

      it 'has rabbit_notification_topic' do
        match = 'rabbit_notification_topic = rabbit_topic'
        expect(chef_run).to render_file(file.name).with_content(match)
      end
    end

    describe 'qpid' do
      let(:file) { chef_run.template('/etc/glance/glance-api.conf') }

      before do
        node.set['openstack']['image']['notification_driver'] = 'messaging'
        node.set['openstack']['mq']['image']['service_type'] = 'qpid'
        node.set['openstack']['mq']['image']['notification_topic'] = 'qpid_topic'
        node.set['openstack']['mq']['image']['qpid']['username'] = 'guest'
      end

      it 'has qpid_hostname' do
        match = 'qpid_hostname=127.0.0.1'
        expect(chef_run).to render_file(file.name).with_content(match)
      end

      it 'has qpid_port' do
        match = 'qpid_port=5672'
        expect(chef_run).to render_file(file.name).with_content(match)
      end

      it 'has qpid_username' do
        match = 'qpid_username=guest'
        expect(chef_run).to render_file(file.name).with_content(match)
      end

      it 'has qpid_password' do
        match = 'qpid_password=mq-pass'
        expect(chef_run).to render_file(file.name).with_content(match)
      end

      it 'has qpid_sasl_mechanisms' do
        match = 'qpid_sasl_mechanisms='
        expect(chef_run).to render_file(file.name).with_content(match)
      end

      it 'has qpid_reconnect' do
        match = 'qpid_reconnect=true'
        expect(chef_run).to render_file(file.name).with_content(match)
      end

      it 'has qpid_reconnect_timeout' do
        match = 'qpid_reconnect_timeout=0'
        expect(chef_run).to render_file(file.name).with_content(match)
      end

      it 'has qpid_reconnect_limit' do
        match = 'qpid_reconnect_limit=0'
        expect(chef_run).to render_file(file.name).with_content(match)
      end

      it 'has qpid_reconnect_interval_min' do
        match = 'qpid_reconnect_interval_min=0'
        expect(chef_run).to render_file(file.name).with_content(match)
      end

      it 'has qpid_reconnect_interval_max' do
        match = 'qpid_reconnect_interval_max=0'
        expect(chef_run).to render_file(file.name).with_content(match)
      end

      it 'has qpid_reconnect_interval' do
        match = 'qpid_reconnect_interval=0'
        expect(chef_run).to render_file(file.name).with_content(match)
      end

      it 'has qpid_heartbeat' do
        match = 'qpid_heartbeat=60'
        expect(chef_run).to render_file(file.name).with_content(match)
      end

      it 'has qpid_protocol' do
        match = 'qpid_protocol=tcp'
        expect(chef_run).to render_file(file.name).with_content(match)
      end

      it 'has qpid_tcp_nodelay' do
        match = 'qpid_tcp_nodelay=true'
        expect(chef_run).to render_file(file.name).with_content(match)
      end

      it 'has qpid_notification_topic' do
        match = 'qpid_notification_topic = qpid_topic'
        expect(chef_run).to render_file(file.name).with_content(match)
      end
    end

    describe 'glance-api-paste.ini' do
      let(:file) { chef_run.template('/etc/glance/glance-api-paste.ini') }

      it 'has proper owner' do
        expect(file.owner).to eq('glance')
        expect(file.group).to eq('glance')
      end

      it 'has proper modes' do
        expect(sprintf('%o', file.mode)).to eq '644'
      end

      it 'template contents' do
        pending 'TODO: implement'
      end

      it 'notifies glance-api restart' do
        expect(file).to notify('service[glance-api]').to(:restart)
      end
    end

    describe 'glance-cache.conf' do
      let(:file) { chef_run.template('/etc/glance/glance-cache.conf') }

      it 'has proper owner' do
        expect(file.owner).to eq('glance')
        expect(file.group).to eq('glance')
      end

      it 'has proper modes' do
        expect(sprintf('%o', file.mode)).to eq '644'
      end

      it 'template contents' do
        pending 'TODO: implement'
      end

      it 'notifies glance-api restart' do
        expect(file).to notify('service[glance-api]').to(:restart)
      end

      it 'has the default image_cache_dir setting' do
        expect(chef_run).to render_file(file.name).with_content(
          %r{^image_cache_dir = /var/lib/glance/image-cache/$})
      end

      it 'has a configurable image_cache_dir setting' do
        node.set['openstack']['image']['cache']['dir'] = 'foo'

        expect(chef_run).to render_file(file.name).with_content(
          /^image_cache_dir = foo$/)
      end

      it 'has the default cache stall_time setting' do
        expect(chef_run).to render_file(file.name).with_content(
          /^image_cache_stall_time = 86400$/)
      end

      it 'has a configurable stall_time setting' do
        node.set['openstack']['image']['cache']['stall_time'] = '42'

        expect(chef_run).to render_file(file.name).with_content(
          /^image_cache_stall_time = 42$/)
      end

      it 'has the default grace_period setting' do
        expect(chef_run).to render_file(file.name).with_content(
          /^image_cache_invalid_entry_grace_period = 3600$/)
      end

      it 'has a configurable grace_period setting' do
        node.set['openstack']['image']['cache']['grace_period'] = '42'

        expect(chef_run).to render_file(file.name).with_content(
          /^image_cache_invalid_entry_grace_period = 42$/)
      end

      [
        /^vmware_server_host = $/,
        /^vmware_server_username = $/,
        /^vmware_server_password = $/,
        /^vmware_datacenter_path = $/,
        /^vmware_datastore_name = $/,
        /^vmware_api_retry_count = 10/,
        /^vmware_task_poll_interval = 5$/,
        /^vmware_store_image_dir = \/openstack_glance$/,
        /^vmware_api_insecure = false$/
      ].each do |content|
        it "has a #{content.source[1...-1]} line" do
          expect(chef_run).to render_file(file.name).with_content(content)
        end
      end
    end

    describe 'glance-cache-paste.ini' do
      let(:file) { chef_run.template('/etc/glance/glance-cache-paste.ini') }

      it 'has proper owner' do
        expect(file.owner).to eq('glance')
        expect(file.group).to eq('glance')
      end

      it 'has proper modes' do
        expect(sprintf('%o', file.mode)).to eq '644'
      end

      it 'template contents' do
        pending 'TODO: implement'
      end

      it 'notifies glance-api restart' do
        expect(file).to notify('service[glance-api]').to(:restart)
      end
    end

    describe 'glance-scrubber.conf' do
      let(:file) { chef_run.template('/etc/glance/glance-scrubber.conf') }

      it 'has proper owner' do
        expect(file.owner).to eq('glance')
        expect(file.group).to eq('glance')
      end

      it 'has proper modes' do
        expect(sprintf('%o', file.mode)).to eq '644'
      end

      it 'template contents' do
        pending 'TODO: implement'
      end
    end

    it 'has glance-cache-pruner cronjob running every 30 minutes' do
      cron = chef_run.cron('glance-cache-pruner')

      expect(cron.command).to eq '/usr/bin/glance-cache-pruner > /dev/null 2>&1'
      expect(cron.minute).to eq '*/30'
    end

    it 'has glance-cache-cleaner to run at 00:01 each day' do
      cron = chef_run.cron('glance-cache-cleaner')

      expect(cron.command).to eq '/usr/bin/glance-cache-cleaner > /dev/null 2>&1'
      expect(cron.minute).to eq '01'
      expect(cron.hour).to eq '00'
    end

    describe 'glance-scrubber-paste.ini' do
      let(:file) { chef_run.template('/etc/glance/glance-scrubber-paste.ini') }

      it 'has proper owner' do
        expect(file.owner).to eq('glance')
        expect(file.group).to eq('glance')
      end

      it 'has proper modes' do
        expect(sprintf('%o', file.mode)).to eq '644'
      end

      it 'template contents' do
        pending 'TODO: implement'
      end
    end
  end
end
