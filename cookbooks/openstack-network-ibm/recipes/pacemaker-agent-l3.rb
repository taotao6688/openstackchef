include_recipe "pacemaker::install"
require "uri"

class ::Chef::Recipe
  include ::Openstack
end

platform_options = node["openstack"]["network"]["platform"]

mq_type = node["openstack"]["compute"]["mq"]["service_type"]
mq_port = node["openstack"]["compute"]["mq"][mq_type]["port"]

op_var = {"monitor" => "interval=20s timeout=20s"}
api_var = {
            "config" => "/etc/quantum/quantum.conf",
            "amqp_server_port" => mq_port,
            }

service "quantum-l3-agent" do
  service_name platform_options["quantum_l3_agent_service"]
  action [:disable, :stop]
end

cookbook_file "copy quantum l3 agent resource agent" do
    path "/usr/lib/ocf/resource.d/openstack/quantum-agent-l3"
    source "quantum-agent-l3"
    owner "root"
    group "root"
    mode "0755"
end

pacemaker_agent "create l3-agent resource agent" do
    pm_resource_name "QUANTUM-AGENT-L3"
    agent_name "ocf:openstack:quantum-agent-l3"
    op_param op_var
    params api_var
    type "active/passive"
end

