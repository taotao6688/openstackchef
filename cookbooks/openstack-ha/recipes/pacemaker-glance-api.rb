include_recipe "pacemaker::install"
require "uri"

class ::Chef::Recipe
  include ::Openstack
end

platform_options = node["openstack"]["image"]["platform"]
api_endpoint = endpoint "image-api"
identity_endpoint = endpoint "identity-api"
#admin_pass = user_password node["openstack"]["identity"]["admin_user"]
admin_pass = get_password 'user', node['openstack']['identity']['admin_user']
api_uri = ::URI.decode api_endpoint.to_s
endpoint_uri = ::URI.decode identity_endpoint.to_s
op_var = {"monitor" => "interval=20s timeout=20s"}
api_var = {
            "config" => "/etc/glance/glance-api.conf",
            "os_password" => admin_pass,
            "os_username" => node["openstack"]["identity"]["admin_user"],
            "os_tenant_name" => node["openstack"]["identity"]["admin_tenant_name"],
            "os_auth_url" => endpoint_uri,
            "os_image_url" => api_uri,
            }

#service "image-api" do
#  service_name platform_options["image_api_service"]
#  action [:disable, :stop]
#end

#cookbook_file "copy glance-api resource agent" do
#    path "/usr/lib/ocf/resource.d/openstack/glance-api"
#    source "glance-api"
#    owner "root"
#    group "root"
#    mode "0755"
#end

pacemaker_agent "create glance-api  agent" do
    pm_resource_name "GLANCE_API"
    agent_name "ocf:openstack:glance-api"
    op_param op_var
    params api_var
    type "clone"
end
