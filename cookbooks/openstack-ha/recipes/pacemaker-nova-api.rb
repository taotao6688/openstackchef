include_recipe "pacemaker::install"
require "uri"

class ::Chef::Recipe
  include ::Openstack
end

platform_options = node["openstack"]["compute"]["platform"]
api_endpoint = endpoint "compute-api"
identity_endpoint = endpoint "identity-api"
#admin_pass = user_password node["openstack"]["identity"]["admin_user"]
admin_pass = get_password 'user', node['openstack']['identity']['admin_user']
api_uri = ::URI.decode api_endpoint.to_s
endpoint_uri = ::URI.decode identity_endpoint.to_s
op_var = {"monitor" => "interval=20s timeout=20s"}
api_var = {
            "config" => "/etc/nova/nova.conf",
            "os_password" => admin_pass,
            "os_username" => node["openstack"]["identity"]["admin_user"],
            "os_tenant_name" => node["openstack"]["identity"]["admin_tenant_name"],
            "keystone_get_token_url" => endpoint_uri+'/tokens',
            "url" => api_uri,
            }

#service "nova-api-os-compute" do
#  service_name platform_options["api_os_compute_service"]
#  action [:disable, :stop]
#end
#
#cookbook_file "copy compute-api resource agent" do
#    path "/usr/lib/ocf/resource.d/openstack/nova-api"
#    source "nova-api"
#    owner "root"
#    group "root"
#    mode "0755"
#end

pacemaker_agent "create compute-api agent" do
    pm_resource_name "NOVA_API"
    agent_name "ocf:openstack:nova-api"
    op_param op_var
    params api_var
    type "clone"
end
