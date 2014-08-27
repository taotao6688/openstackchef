include_recipe "pacemaker::install"
require "uri"

class ::Chef::Recipe
  include ::Openstack
end

platform_options = node["openstack"]["block-storage"]["platform"]
api_endpoint = endpoint "volume-api"
identity_endpoint = endpoint "identity-api"
#admin_pass = user_password node["openstack"]["identity"]["admin_user"]
admin_pass = get_password 'user', node['openstack']['identity']['admin_user']

api_uri = ::URI.decode api_endpoint.to_s
endpoint_uri = ::URI.decode identity_endpoint.to_s
op_var = {"monitor" => "interval=20s timeout=20s"}
api_var = {
            "config" => "/etc/cinder/cinder.conf",
            "os_password" => admin_pass,
            "os_username" => node["openstack"]["identity"]["admin_user"],
            "os_tenant_name" => node["openstack"]["identity"]["admin_tenant_name"],
            "keystone_get_token_url" => endpoint_uri+'/tokens',
            "url" => api_uri,
            }

service "cinder-api" do
  service_name platform_options["cinder_api_service"]
  action [:disable, :stop]
end

execute "modify log owner" do
  command "chown cinder:cinder /var/log/cinder/ -R"
end

cookbook_file "copy cinder-api resource agent" do
    path "/usr/lib/ocf/resource.d/openstack/cinder-api"
    source "cinder-api"
    owner "root"
    group "root"
    mode "0755"
end

pacemaker_agent "create cinder-api  agent" do
    pm_resource_name "CINDER_API"
    agent_name "ocf:openstack:cinder-api"
    op_param op_var
    params api_var
    type "clone"
end
