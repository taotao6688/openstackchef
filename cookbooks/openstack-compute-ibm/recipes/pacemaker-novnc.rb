include_recipe "pacemaker::install"
require "uri"

class ::Chef::Recipe
  include ::Openstack
end

platform_options = node["openstack"]["compute"]["platform"]
mq_port = node["openstack"]["endpoints"]["mq"]["port"]


op_var = {"monitor" => "interval=20s timeout=20s"}
api_var = {
            "web" => "/usr/share/novnc/",
            }

service "nova-novncproxy" do
  service_name platform_options["compute_vncproxy_service"]
  action [:disable, :stop]
end

cookbook_file "copy nova-novnc resource agent" do
    path "/usr/lib/ocf/resource.d/openstack/nova-novnc"
    source "nova-novnc"
    owner "root"
    group "root"
    mode "0755"
end

pacemaker_agent "create nova-novnc agent" do
    pm_resource_name "NOVA_NOVNC"
    agent_name "ocf:openstack:nova-novnc"
    op_param op_var
    params api_var
    type "clone"
end
