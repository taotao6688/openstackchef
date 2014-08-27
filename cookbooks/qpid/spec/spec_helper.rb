# encoding: UTF-8
# Added by ChefSpec
require 'chefspec'

# Use ChefSpec's Berkshelf extension
require 'chefspec/berkshelf'

::LOG_LEVEL = :fatal
::REDHAT_OPTS = {
  platform: 'redhat',
  version: '6.5',
  log_level: ::LOG_LEVEL,
  step_into: ['qpid_setup']
}

shared_context 'qpid-stubs' do
  before do
    Chef::Recipe.any_instance.stub(:address_for)
      .with('lo')
      .and_return('127.0.1.1')
  end
end

RSpec.configure do |config|
  # Specify the path for Chef Solo to find cookbooks
  # config.cookbook_path = '/var/cookbooks'

  # Specify the path for Chef Solo to find roles
  # config.role_path = '/var/roles'

  # Specify the Chef log_level (default: :warn)
  # config.log_level = :debug

  # Specify the path to a local JSON file with Ohai data
  # config.path = 'ohai.json'

  # Specify the operating platform to mock Ohai data from
  # config.platform = 'redhat'

  # Specify the operating version to mock Ohai data from
  # config.version = '6.5'
end

ChefSpec::Coverage.start!
