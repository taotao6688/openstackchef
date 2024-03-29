# encoding: UTF-8
require 'chefspec'
require 'chefspec/berkshelf'

ChefSpec::Coverage.start! { add_filter 'openstack-common' }

LOG_LEVEL = :fatal
UBUNTU_OPTS = {
  platform: 'ubuntu',
  version: '12.04',
  log_level: LOG_LEVEL
}
REDHAT_OPTS = {
  platform: 'redhat',
  version: '6.5',
  log_level: LOG_LEVEL
}
SUSE_OPTS = {
  platform: 'suse',
  version: '11.03',
  log_lovel: LOG_LEVEL
}
# We set a default platform for non-platform specific test cases
CHEFSPEC_OPTS = UBUNTU_OPTS

shared_context 'library-stubs' do
  before do
    subject.stub(:node).and_return(chef_run.node)
  end
end
