include_recipe "pacemaker::install"
require "uri"

class ::Chef::Recipe
  include ::Openstack
end

platform_options = node["openstack"]["compute"]["platform"]
mq_port = node["openstack"]["endpoints"]["mq"]["port"]


op_var = {"monitor" => "interval=20s timeout=20s"}
api_var = {
            "config" => "/etc/nova/nova.conf",
            "amqp_server_port" => mq_port,
            }

#service "nova-cert" do
#  service_name platform_options["compute_cert_service"]
#  action [:disable, :stop]
#end
#
#cookbook_file "copy nova-cert resource agent" do
#    path "/usr/lib/ocf/resource.d/openstack/nova-cert"
#    source "nova-cert"
#    owner "root"
#    group "root"
#    mode "0755"
#end

pacemaker_agent "create nova-cert agent" do
    pm_resource_name "NOVA_CERT"
    agent_name "ocf:openstack:nova-cert"
    op_param op_var
    params api_var
    type "clone"
end
