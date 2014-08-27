# encoding: UTF-8
require_relative 'spec_helper'

describe 'qpid::single' do
  describe 'redhat' do
    let(:runner) { ChefSpec::Runner.new(REDHAT_OPTS) }
    let(:node) { runner.node }
    let(:chef_run) { runner.converge(described_recipe) }

    include_context 'qpid-stubs'

    it 'installs qpid packages' do
      %w(qpid-cpp-server qpid-tools python-qpid-qmf).each do |pkg|
        expect(chef_run).to upgrade_package(pkg)
      end
    end

    describe '/var/log/qpid' do
      let(:dir) { chef_run.directory('/var/log/qpid') }

      it 'has proper owner' do
        expect(dir.owner).to eq('qpidd')
        expect(dir.group).to eq('qpidd')
      end

      it 'has proper modes' do
        expect(format('%o', dir.mode)).to eq '744'
      end
    end

    describe 'qpidd.log' do
      let(:file) { chef_run.file('/var/log/qpid/qpidd.log') }

      it 'has proper owner' do
        expect(file.owner).to eq('qpidd')
        expect(file.group).to eq('qpidd')
      end

      it 'has proper modes' do
        expect(format('%o', file.mode)).to eq '644'
      end
    end

    describe 'qpidd.conf' do
      let(:template) { chef_run.template('/etc/qpid/qpidd.conf') }

      it 'has proper owner' do
        expect(template.owner).to eq('root')
        expect(template.group).to eq('root')
      end

      it 'has proper modes' do
        expect(format('%o', template.mode)).to eq '644'
      end

      it 'notifies qpidd restart' do
        expect(template).to notify('service[qpidd]').to(:restart)
      end
    end

    it 'verifies default qpid attributes' do
      expect(chef_run.node['qpid']['broker']['port']).to eql 5672
      expect(chef_run.node['qpid']['broker']['auth']).to eql 'no'
      expect(chef_run.node['qpid']['broker']['max-connections']).to eql 2000
      expect(chef_run.node['qpid']['broker']['connection-backlog']).to eql 1000
      expect(chef_run.node['qpid']['broker']['worker-threads']).to eql 100
      expect(chef_run.node['qpid']['broker']['max-negotiate-time']).to eql 60000
      expect(chef_run.node['qpid']['broker']['link-heartbeat-interval']).to eql 1200
      expect(chef_run.node['qpid']['broker']['log-enable']).to eql 'info+'
      expect(chef_run.node['qpid']['broker']['log-to-file']).to eql '/var/log/qpid/qpidd.log'
    end

    it 'starts qpid on boot' do
      expect(chef_run).to enable_service('qpidd')
    end

    it 'sleep on qpid service enable' do
      expect(chef_run.service('qpidd')).to notify(
        'execute[qpidd: sleep]').to(:run)
    end

  end
end
