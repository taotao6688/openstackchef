# encoding: UTF-8
#
# Cookbook Name:: openstack-block-storage

require_relative 'spec_helper'

describe 'openstack-block-storage::scheduler' do
  describe 'redhat' do
    let(:runner) { ChefSpec::Runner.new(REDHAT_OPTS) }
    let(:node) { runner.node }
    let(:chef_run) { runner.converge(described_recipe) }

    include_context 'block-storage-stubs'

    it 'installs cinder scheduler packages' do
      expect(chef_run).to upgrade_package 'openstack-cinder'
    end

    it 'starts cinder scheduler' do
      expect(chef_run).to start_service 'openstack-cinder-scheduler'
    end

    it 'starts cinder scheduler on boot' do
      expect(chef_run).to enable_service 'openstack-cinder-scheduler'
    end

    it 'does not upgrade stevedore' do
      expect(chef_run).not_to upgrade_python_pip 'stevedore'
    end

    it 'installs mysql python packages by default' do
      expect(chef_run).to upgrade_package 'MySQL-python'
    end

    it 'installs db2 python packages if explicitly told' do
      node.set['openstack']['db']['block-storage']['service_type'] = 'db2'

      ['python-ibm-db', 'python-ibm-db-sa'].each do |pkg|
        expect(chef_run).to upgrade_package pkg
      end
    end

    it 'installs postgresql python packages if explicitly told' do
      node.set['openstack']['db']['block-storage']['service_type'] = 'postgresql'

      expect(chef_run).to upgrade_package 'python-psycopg2'
      expect(chef_run).not_to upgrade_package 'MySQL-python'
    end
  end
end
