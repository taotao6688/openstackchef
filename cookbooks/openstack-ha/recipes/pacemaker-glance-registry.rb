include_recipe "pacemaker::install"
require "uri"

class ::Chef::Recipe
  include ::Openstack
end

platform_options = node["openstack"]["image"]["platform"]
registry_endpoint = endpoint "image-registry"
identity_endpoint = endpoint "identity-api"
#admin_pass = user_password node["openstack"]["identity"]["admin_user"]
admin_pass = get_password 'user', node['openstack']['identity']['admin_user']
registry_uri = ::URI.decode registry_endpoint.to_s
endpoint_uri = ::URI.decode identity_endpoint.to_s
op_var = {"monitor" => "interval=20s timeout=20s"}

registry_var = {
            "config" => "/etc/glance/glance-registry.conf",
            "os_password" => admin_pass,
            "os_username" => node["openstack"]["identity"]["admin_user"],
            "os_tenant_name" => node["openstack"]["identity"]["admin_tenant_name"],
            "keystone_get_token_url" => endpoint_uri+"/tokens",
            "url" => registry_uri,
            }

#service "image-registry" do
#  service_name platform_options["image_registry_service"]
#  action [:disable, :stop]
#end
#
#cookbook_file "copy glance-registry resource agent" do
#    path "/usr/lib/ocf/resource.d/openstack/glance-registry"
#    source "glance-registry"
#    owner "root"
#    group "root"
#    mode "0755"
#end

pacemaker_agent "create glance-registry  agent" do
    pm_resource_name "GLANCE_REGISTRY"
    agent_name "ocf:openstack:glance-registry"
    op_param op_var
    params registry_var
    type "clone"
end
