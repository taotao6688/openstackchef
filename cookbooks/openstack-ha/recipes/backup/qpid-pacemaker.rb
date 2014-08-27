#
# Cookbook Name:: openstack-ha
# Recipe:: qpid-ha-active
#
# Copyright 2013, IBM, Corp.
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

qpid_ha_setup "setup qpid active" do

  ha_public_url   node['openstack']['mq']['qpid']['vip']
  ha_brokers_url  node['openstack']['mq']['qpid']['nodes']

  action :create

end

