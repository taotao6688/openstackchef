# encoding: UTF-8
#
# Cookbook Name:: openstack-ops-database
# Recipe:: db2-server
#
# Copyright 2014, IBM Corp.
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
#

class ::Chef::Recipe # rubocop:disable Documentation
  include ::Openstack
end

das_password = get_password('user', 'db2_das')
fenced_password = get_password('user', 'db2_fenced')
instance_password = get_password('user', 'db2_instance')

## install db2 server
db2_server 'install db2 server for OpenStack' do
  url node['openstack']['db']['db2']['url']
  port node['openstack']['db']['db2']['port']
  version node['openstack']['db']['db2']['version']
  fcm_port node['openstack']['db']['db2']['fcm_port']
  das_username node['openstack']['db']['db2']['das_username']
  req_packages node['openstack']['db']['db2']['req_packages']
  download_dir node['openstack']['db']['db2']['download_dir']
  instance_type node['openstack']['db']['db2']['instance_type']
  fenced_username node['openstack']['db']['db2']['fenced_username']
  instance_username node['openstack']['db']['db2']['instance_username']
  max_logical_nodes node['openstack']['db']['db2']['max_logical_nodes']
  das_password das_password
  fenced_password fenced_password
  instance_password instance_password
  action :install
end

## override databases and database users
## db2 database and user name should be no more than 8 characters
## db2 uses system user as database user, so should avoid using OpenStack service users
hash = {
  'compute' => 'nova',
  'dashboard' => 'horizon',
  'identity' => 'keystone',
  'image' => 'glance',
  'telemetry' => 'ceilometer',
  'network' => 'neutron',
  'block-storage' => 'cinder',
  'orchestration' => 'heat'
}
%w(compute dashboard identity image telemetry network block-storage orchestration).each do |service|
  ## create database, one db2 database for OpenStack is enough
  db2_database "create db2 database for service #{service}" do
    db_name node['openstack']['db'][service]['db_name']
    pagesize node['openstack']['db']['db2']['db_pagesize']
    territory node['openstack']['db']['db2']['db_territory']
    database_data_dir node['openstack']['db']['db2']['database_data_dir']
    instance_username node['openstack']['db']['db2']['instance_username']
    action :create
  end

  db_pass = get_password('db', hash[service])
  db2_user "create database user for service #{service}" do
    db_user node['openstack']['db'][service]['username']
    db_pass db_pass
    db_name node['openstack']['db'][service]['db_name']
    privileges node['openstack']['db']['db2']['db_privileges']
    instance_username node['openstack']['db']['db2']['instance_username']
    action :create
  end

  if service == 'telemetry'
    db_info = db 'telemetry'
    db2_nosql 'Enable NoSQL on DB2' do
      database_username node['openstack']['db'][service]['username']
      database_name node['openstack']['db'][service]['db_name']
      database_user_password db_pass
      database_host db_info['host']
      database_port db_info['port']
      database_mongo_port db_info['nosql']['port']
      instance_username node['openstack']['db']['db2']['instance_username']
      action :enable
    end
  end

end
