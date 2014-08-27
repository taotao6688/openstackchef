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

vip = node['openstack']['mq']['qpid']['vip']
vrrp_iface = node['openstack']['mq']['qpid']['keepalived_vrrp_iface']
##========================================

include_recipe "keepalived::install"

vi_name = "vi_#{vip.gsub(/\./, '_')}"
router_id = vip.split(".")[3]

keepalived_chkscript "chk_qpid_status" do
    script "/sbin/service qpidd status"
    interval 1
    weight -10
    rise 1
    fall 1
    action :create
end

keepalived_vrrp vi_name do
	state 'BACKUP'
    interface vrrp_iface
    virtual_router_id router_id.to_i
    priority 100
    advert_int 1

    auth_type 'pass'
    auth_pass "^123#{router_id}$"

    virtual_ipaddress Array(vip)

    track_script 'chk_qpid_status'

    notify_master "/usr/bin/qpid-ha promote"
    notify_backup "/sbin/service qpidd restart"
    notify_fault "/sbin/service qpidd restart"
    action :create
end
