vip = node['openstack']['mq']['qpid']['vip']
#vip_if = node['openstack']['mq']['vip_if']
##========================================
#
include_recipe "pacemaker::install"
op_var_master = {"monitor" => "interval=5s timeout=30s role='Master'"}
op_var_slave = {"monitor" => "interval=10s timeout=30s"}
op_var = {"monitor" => "interval=2s timeout=15s"}
agent_var = {}

#service "qpid" do
#  service_name "qpidd"
#  action [:disable, :stop]
#end

pacemaker_vip "create vip" do
  resource "QPID"
  ip vip
  cidr_netmask "32"
  op_param op_var
end

#cookbook_file "copy resource agent" do
#    path "/usr/lib/ocf/resource.d/openstack/qpidd"
#    source "qpidd"
#    owner "root"
#    group "root"
#    mode "0755"
#end

pacemaker_agent "create qpidd agent" do
    pm_resource_name "QPID"
    agent_name "ocf:openstack:qpidd"
    op_param op_var_master
    params agent_var
    type "master"
end

pacemaker_agent "add monitor operation" do
    pm_resource_name "QPID"
    op_param op_var_slave
    action :add_operation
end

execute "add colocation constraint" do
    command "pcs constraint colocation add QPID_VIP QPID-master INFINITY with-rsc-role=Master"
end

execute "add handover order constraint" do
    command "pcs constraint order promote QPID-master then start QPID_VIP"
end
