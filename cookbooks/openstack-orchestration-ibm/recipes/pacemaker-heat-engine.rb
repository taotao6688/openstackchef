include_recipe "pacemaker::install"
require "uri"

class ::Chef::Recipe
  include ::Openstack
end

platform_options = node['openstack']['orchestration']['platform']
op_var = {"monitor" => "interval=20s"}

service "heat-engine" do
  service_name platform_options["heat_engine_service"]
  action [:disable, :stop]
end

cookbook_file "copy heat-engine resource agent" do
    path "/usr/lib/ocf/resource.d/openstack/heat-engine"
    source "heat-engine"
    owner "root"
    group "root"
    mode "0755"
end

pacemaker_agent "create heat-engine agent" do
    pm_resource_name "HEAT_ENGINE"
    agent_name "ocf:openstack:heat-engine"
    op_param op_var
    type "clone"
end
