#
# Cookbook Name:: openstack-ops-database
# Recipe:: db2-standby
#
# Copyright 2013, IBM
#
# All rights reserved - Do Not Redistribute
#

class ::Chef::Recipe # rubocop:disable Documentation
  include ::Openstack
end

instance_password = get_password('user', 'db2_instance')

db2_standby 'setup DB2 standby for OpenStack' do
  db_name      node['openstack']['db']['db2']['db_name']
  primary_host node['openstack']['db']['db2']['primary_host']
  primary_port node['openstack']['db']['db2']['primary_port']
  standby_host node['openstack']['db']['db2']['standby_host']
  standby_port node['openstack']['db']['db2']['standby_port']
  instance_username node['openstack']['db']['db2']['instance_username']
  instance_password instance_password
  action :setup
end

vip = node['openstack']['db']['db2']['vip']
vip_iface = node['openstack']['db']['db2']['keepalived_vrrp_iface']
db_name = node['openstack']['db']['db2']['db_name']
instance_username = node['openstack']['db']['db2']['instance_username']

##==================================================

include_recipe 'keepalived::install'

Chef::Log.info('Configuring vrrp instance for DB2 HA')

vi_name = "vi_#{vip.gsub(/\./, '_')}"
router_id = vip.split(".")[3]

keepalived_chkscript 'chk_db2_status' do
    script "su - #{instance_username} -c 'db2pd -db #{db_name} -hadr'"
    interval 10
    weight -10
    rise 1
    fall 1
    action :create
end

keepalived_vrrp vi_name do
    state 'BACKUP'
    interface vip_iface
    virtual_router_id router_id.to_i  # Needs to be a integer between 0..255
    priority 100
    advert_int 1
  
    auth_type 'pass'
    auth_pass "^123#{router_id}$"
  
    virtual_ipaddress Array(vip)
    # virtual_ipaddress Array("#{vip}/16 brd 172.16.255.255")
  
    track_script 'chk_db2_status'
  
    notify_master "/bin/su - #{instance_username} -c 'db2 takeover hadr on db #{db_name} by force'"
    notify_backup "/bin/su - #{instance_username} -c 'db2 start hadr on db #{db_name} as standby'"
    notify_fault '/bin/echo ok'
    action :create
end
