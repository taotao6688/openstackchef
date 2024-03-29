# encoding: UTF-8
#
# Cookbook Name:: openstack-ops-database
# Recipe:: db2-client
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

## install db2 client
## actually this is db2 odbc driver, not client
db2_odbc 'install db2 driver for OpenStack' do
  url node['openstack']['db']['db2']['odbc_url']
  download_dir node['openstack']['db']['db2']['download_dir']
  action :install
end
