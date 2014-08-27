include_recipe "pacemaker::install"
require "uri"

class ::Chef::Recipe
  include ::Openstack
end

platform_options = node["openstack"]["network"]["platform"]

#mq_type = node["openstack"]["compute"]["mq"]["service_type"]
#mq_port = node["openstack"]["compute"]["mq"][mq_type]["port"]
mq_port = node["openstack"]["endpoints"]["mq"]["port"]

op_var = {"monitor" => "interval=20s timeout=20s"}
api_var = {
            "config" => "/etc/neutron/neutron.conf",
            }

#service "metadata-agent" do
#  service_name platform_options["neutron_metadata_agent_service"]
#  action [:disable, :stop]
#end
#
#cookbook_file "copy neutron metadata agent resource agent" do
#    path "/usr/lib/ocf/resource.d/openstack/neutron-metadata-agent"
#    source "neutron-metadata-agent"
#    owner "root"
#    group "root"
#    mode "0755"
#end

pacemaker_agent "create metadata-agent agent" do
    pm_resource_name "NEUTRON-AGENT-METADATA"
    agent_name "ocf:openstack:neutron-metadata-agent"
    op_param op_var
    params api_var
    type "clone"
end

