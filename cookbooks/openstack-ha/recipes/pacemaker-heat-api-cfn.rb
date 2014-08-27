include_recipe "pacemaker::install"
require "uri"

class ::Chef::Recipe
  include ::Openstack
end

platform_options = node['openstack']['orchestration']['platform']
op_var = {"monitor" => "interval=20s"}

#service "heat-api-cfn" do
#  service_name platform_options["heat_api_cfn_service"]
#  action [:disable, :stop]
#end
#
#cookbook_file "copy heat-api-cfn resource agent" do
#    path "/usr/lib/ocf/resource.d/openstack/heat-api-cfn"
#    source "heat-api-cfn"
#    owner "root"
#    group "root"
#    mode "0755"
#end

pacemaker_agent "create heat-api-cfn agent" do
    pm_resource_name "HEAT_API_CFN"
    agent_name "ocf:openstack:heat-api-cfn"
    op_param op_var
    type "clone"
end
