# encoding: UTF-8
#
# Cookbook Name:: openstack-object-storage
# Recipe:: proxy-server
#
# Copyright 2012, Rackspace US, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

include_recipe 'openstack-object-storage::common'
include_recipe 'openstack-object-storage::memcached'

class Chef::Recipe # rubocop:disable Documentation
  include IPUtils
end

if node.run_list.expand(node.chef_environment).recipes.include?('openstack-object-storage::setup')
  Chef::Log.info('I ran the openstack-object-storage::setup so I will use my own swift passwords')
else
  setup_role = node['openstack']['object-storage']['setup_chef_role']
  setup = search(:node, "chef_environment:#{node.chef_environment} AND roles:#{setup_role}")
  if setup.length == 0
    Chef::Application.fatal! 'You must have run the openstack-object-storage::setup recipe (on this or another node) before running the swift::proxy recipe on this node'
  elsif setup.length == 1
    Chef::Log.info "Found openstack-object-storage::setup node: #{setup[0].name}"
    node.set['openstack']['object-storage']['service_pass'] = setup[0]['swift']['service_pass']
  elsif setup.length > 1
    Chef::Application.fatal! 'You have multiple nodes in your environment that have run swift-setup, and that is not allowed'
  end
end

platform_options = node['openstack']['object-storage']['platform']

# install platform-specific packages
platform_options['proxy_packages'].each do |pkg|
  package pkg do
    action :install
    options platform_options['override_options']
  end
end

if node['openstack']['object-storage']['authmode'] == 'swauth'
  case node['openstack']['object-storage']['swauth_source']
  when 'package'
    platform_options['swauth_packages'].each do |pkg|
      package pkg do
        action :install
        options platform_options['override_options']
      end
    end
  when 'git'
    git "#{Chef::Config[:file_cache_path]}/swauth" do
      repository node['openstack']['object-storage']['swauth_repository']
      revision   node['openstack']['object-storage']['swauth_version']
      action :sync
    end

    bash 'install_swauth' do
      cwd "#{Chef::Config[:file_cache_path]}/swauth"
      user 'root'
      group 'root'
      code <<-EOH
        python setup.py install
      EOH
      environment 'PREFIX' => '/usr/local'
    end
  end
end

package 'python-swift-informant' do
  action :install
  only_if { node['openstack']['object-storage']['use_informant'] }
end

package 'python-keystone' do
  action :install
  only_if { node['openstack']['object-storage']['authmode'] == 'keystone' }
end

directory '/var/cache/swift' do
  owner 'swift'
  group 'swift'
  mode 00700
end

swift_proxy_service = platform_options['service_prefix'] + 'swift-proxy' + platform_options['service_suffix']
service 'swift-proxy' do
  # openstack-swift-proxy.service on fedora-17, swift-proxy on ubuntu
  service_name swift_proxy_service
  provider platform_options['service_provider']
  supports status: true, restart: true
  action [:enable, :start]
  only_if '[ -e /etc/swift/proxy-server.conf ] && [ -e /etc/swift/object.ring.gz ]'
end

# use localhost  when using chef solo otherwise, include all memcache
# servers from all known proxies
if Chef::Config[:solo]
  memcache_servers = ['127.0.0.1:11211']
else
  memcache_servers = []
  proxy_role = node['openstack']['object-storage']['proxy_server_chef_role']
  proxy_nodes = search(:node, "chef_environment:#{node.chef_environment} AND roles:#{proxy_role}")
  proxy_nodes.each do |proxy|
    proxy_ip = locate_ip_in_cidr(node['openstack']['object-storage']['network']['proxy-cidr'], proxy)
    next unless proxy_ip # skip nil ips so we dont break the config
    server_str = "#{proxy_ip}:11211"
    memcache_servers << server_str unless memcache_servers.include?(server_str)
  end
end

# determine authkey to use
if node['openstack']['object-storage']['swift_secret_databag_name'].nil?
  authkey = node['openstack']['object-storage']['authkey']
else
  swift_secrets = Chef::EncryptedDataBagItem.load 'secrets', node['openstack']['object-storage']['swift_secret_databag_name']
  authkey = swift_secrets['swift_authkey']
end

# create proxy config file
template '/etc/swift/proxy-server.conf' do
  source 'proxy-server.conf.erb'
  owner 'swift'
  group 'swift'
  mode 0600
  variables(
    'authmode' => node['openstack']['object-storage']['authmode'],
    'bind_host' => node['openstack']['object-storage']['network']['proxy-bind-ip'],
    'bind_port' => node['openstack']['object-storage']['network']['proxy-bind-port'],
    'authkey' => authkey,
    'memcache_servers' => memcache_servers
  )
  notifies :restart, 'service[swift-proxy]', :immediately
end
