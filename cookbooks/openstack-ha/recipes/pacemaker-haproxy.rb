include_recipe "pacemaker::install"
require "uri"

class ::Chef::Recipe
  include ::Openstack
end

#platform_options = node["openstack"]["identity"]["platform"]
op_var = {"monitor" => "interval=10s"}
agent_var = { "conffile" => "/etc/haproxy/haproxy.cfg" }

vip = node['openstack']['ha']['endpoints']['vip']
pacemaker_vip "create vip" do
    resource "HAPROXY"
    ip vip
    cidr_netmask "32"
    op_param op_var
end

#service "haproxy" do
#  service_name "haproxy"
#  action [:disable, :stop]
#end
#
#cookbook_file "copy resource agent" do
#    path "/usr/lib/ocf/resource.d/heartbeat/haproxy"
#    source "haproxy"
#    owner "root"
#    group "root"
#    mode "0755"
#end

pacemaker_agent "create haproxy agent" do
    pm_resource_name "HAPROXY"
    agent_name "ocf:heartbeat:haproxy"
    op_param op_var
    params agent_var
    type "clone"
end
