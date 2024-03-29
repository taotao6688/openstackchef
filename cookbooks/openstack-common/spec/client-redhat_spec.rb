# encoding: UTF-8
require_relative 'spec_helper'

describe 'openstack-common::client' do

  describe 'redhat' do

    let(:runner) { ChefSpec::Runner.new(REDHAT_OPTS) }
    let(:node) { runner.node }
    let(:chef_run) do
      runner.converge(described_recipe)
    end

    it 'installs common client packages' do
      expect(chef_run).to upgrade_package('python-openstackclient')
    end
  end
end
