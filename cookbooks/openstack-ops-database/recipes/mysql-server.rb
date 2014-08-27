# encoding: UTF-8
#
# Cookbook Name:: openstack-ops-database
# Recipe:: mysql-server
#
# Copyright 2013, Opscode, Inc.
# Copyright 2012-2013, Rackspace US, Inc.
# Copyright 2013, AT&T Services, Inc.
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

db_endpoint = endpoint 'db'

node.override['mysql']['bind_address'] = db_endpoint.host
node.override['mysql']['tunable']['innodb_thread_concurrency'] = '0'
node.override['mysql']['tunable']['innodb_commit_concurrency'] = '0'
node.override['mysql']['tunable']['innodb_read_io_threads'] = '4'
node.override['mysql']['tunable']['innodb_flush_log_at_trx_commit'] = '2'
node.override['mysql']['tunable']['skip-name-resolve'] = true

include_recipe 'mysql::server'

# NOTE:(mancdaz) This is a temporary workaround for this upstream bug in the
# mysql cookbook. It can be removed once the upstream issue is resolved:
#
# https://tickets.opscode.com/browse/COOK-4161
case node['platform_family']
when 'debian'
  mycnf_template = '/etc/mysql/my.cnf'
when 'rhel'
  mycnf_template = 'final-my.cnf'
end

r = resources("template[#{mycnf_template}]")
r.notifies_immediately(:restart, 'service[mysql]')
