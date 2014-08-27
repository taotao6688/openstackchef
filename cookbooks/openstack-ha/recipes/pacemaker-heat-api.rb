include_recipe "pacemaker::install"
require "uri"

class ::Chef::Recipe
  include ::Openstack
end

platform_options = node['openstack']['orchestration']['platform']
op_var = {"monitor" => "interval=20s"}

#service "heat-api" do
#  service_name platform_options["heat_api_service"]
#  action [:disable, :stop]
#end
#
#cookbook_file "copy heat-api resource agent" do
#    path "/usr/lib/ocf/resource.d/openstack/heat-api"
#    source "heat-api"
#    owner "root"
#    group "root"
#    mode "0755"
#end

pacemaker_agent "create heat-api agent" do
    pm_resource_name "HEAT_API"
    agent_name "ocf:openstack:heat-api"
    op_param op_var
    type "clone"
end
