include_recipe "pacemaker::install"
require "uri"

class ::Chef::Recipe
  include ::Openstack
end

platform_options = node["openstack"]["identity"]["platform"]
identity_admin_endpoint = endpoint "identity-admin"
identity_endpoint = endpoint "identity-api"
#admin_pass = user_password node["openstack"]["identity"]["admin_user"]
admin_pass = get_password 'user', node['openstack']['identity']['admin_user']
#bootstrap_token = secret "secrets", "openstack_identity_bootstrap_token"
bootstrap_token = get_secret 'openstack_identity_bootstrap_token'

auth_uri = ::URI.decode identity_admin_endpoint.to_s
endpoint_uri = ::URI.decode identity_endpoint.to_s
op_var = {"monitor" => "interval=20s timeout=30s"}
agent_var = {
            "config" => "/etc/keystone/keystone.conf",
            "os_password" => admin_pass,
            "os_username" => node["openstack"]["identity"]["admin_user"],
            "os_tenant_name" => node["openstack"]["identity"]["admin_tenant_name"],
            "os_auth_url" => endpoint_uri,
            "os_endpoint" => auth_uri,
            "os_token" => bootstrap_token
            }

#service "keystone" do
#  service_name platform_options["keystone_service"]
#  action [:disable, :stop]
#end

#cookbook_file "copy resource agent" do
#    path "/usr/lib/ocf/resource.d/openstack/keystone"
#    source "keystone"
#    owner "root"
#    group "root"
#    mode "0755"
#end

pacemaker_agent "create keystone agent" do
    pm_resource_name "KEYSTONE"
    agent_name "ocf:openstack:keystone"
    op_param op_var
    params agent_var
    type "clone"
end
