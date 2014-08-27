include_recipe "pacemaker::install"
require "uri"

class ::Chef::Recipe
  include ::Openstack
end

platform_options = node["openstack"]["network"]["platform"]
api_endpoint = endpoint "network-api"
identity_endpoint = endpoint "identity-api"
#admin_pass = user_password node["openstack"]["identity"]["admin_user"]
admin_pass = get_password 'user', node['openstack']['identity']['admin_user']
api_uri = ::URI.decode api_endpoint.to_s
endpoint_uri = ::URI.decode identity_endpoint.to_s
op_var = {"monitor" => "interval=20s timeout=20s"}
api_var = {
            "config" => "/etc/neutron/neutron.conf",
            "os_password" => admin_pass,
            "os_username" => node["openstack"]["identity"]["admin_user"],
            "os_tenant_name" => node["openstack"]["identity"]["admin_tenant_name"],
            "keystone_get_token_url" => endpoint_uri+'/tokens',
            "url" => api_uri,
            }

#service "neutron-server" do
#  service_name platform_options["neutron_server_service"]
#  action [:disable, :stop]
#end
#
#cookbook_file "copy neutron-server resource agent" do
#    path "/usr/lib/ocf/resource.d/openstack/neutron-server"
#    source "neutron-server"
#    owner "root"
#    group "root"
#    mode "0755"
#end

pacemaker_agent "create neutron-server agent" do
    pm_resource_name "NEUTRON_SERVER"
    agent_name "ocf:openstack:neutron-server"
    op_param op_var
    params api_var
    type "clone"
end
