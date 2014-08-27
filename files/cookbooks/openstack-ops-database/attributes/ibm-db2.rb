# encoding: UTF-8
#
# Cookbook Name:: openstack-ops-database
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

## OpenStack DB2 configuration
## This needs db2 cookbook
default['openstack']['db']['db2']['url'] = node['db2']['url']
default['openstack']['db']['db2']['port'] = node['db2']['port']
default['openstack']['db']['db2']['version'] = node['db2']['version']
default['openstack']['db']['db2']['fcm_port'] = node['db2']['fcm_port']
default['openstack']['db']['db2']['max_logical_nodes'] = node['db2']['max_logical_nodes']
default['openstack']['db']['db2']['instance_type'] = node['db2']['instance_type']
default['openstack']['db']['db2']['instance_username'] = node['db2']['instance_username']
default['openstack']['db']['db2']['fenced_username'] = node['db2']['fenced_username']
default['openstack']['db']['db2']['das_username'] = node['db2']['das_username']
default['openstack']['db']['db2']['req_packages'] = node['db2']['req_packages']
default['openstack']['db']['db2']['download_dir'] = node['db2']['download_dir']

default['openstack']['db']['db2']['db_name'] = 'openstac'
default['openstack']['db']['db2']['db_pagesize'] = node['db2']['db_pagesize']
default['openstack']['db']['db2']['db_territory'] = node['db2']['db_territory']
default['openstack']['db']['db2']['database_data_dir'] = node['db2']['database_data_dir']

default['openstack']['db']['db2']['db_privileges'] = node['db2']['db_privileges']

default['openstack']['db']['db2']['odbc_url'] = node['db2']['odbc_url']
