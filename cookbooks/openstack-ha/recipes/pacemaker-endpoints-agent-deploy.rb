include_recipe "pacemaker::install"
require "uri"

class ::Chef::Recipe
  include ::Openstack
end

service "keystone" do
  service_name node["openstack"]["identity"]["platform"]["keystone_service"]
  action [:disable, :stop]
end

service "image-api" do
  service_name node["openstack"]["image"]["platform"]["image_api_service"]
  action [:disable, :stop]
end

service "image-registry" do
  service_name node["openstack"]["image"]["platform"]["image_registry_service"]
  action [:disable, :stop]
end

service "neutron-server" do
  service_name node["openstack"]["network"]["platform"]["neutron_server_service"]
  action [:disable, :stop]
end

service "neutron-dhcp-agent" do
  service_name node["openstack"]["network"]["platform"]["neutron_dhcp_agent_service"]
  action [:disable, :stop]
end

service "metadata-agent" do
  service_name node["openstack"]["network"]["platform"]["neutron_metadata_agent_service"]
  action [:disable, :stop]
end

service "cinder-api" do
  service_name node["openstack"]["block-storage"]["platform"]["cinder_api_service"]
  action [:disable, :stop]
end

execute "modify cinder log owner" do
  command "chown cinder:cinder /var/log/cinder/ -R"
end

service "cinder-scheduler" do
  service_name node["openstack"]["block-storage"]["platform"]["cinder_scheduler_service"]
  action [:disable, :stop]
end

service "cinder-volume" do
  service_name node["openstack"]["block-storage"]["platform"]["cinder_volume_service"]
  action [:disable, :stop]
end

service "nova-api-os-compute" do
  service_name node["openstack"]["compute"]["platform"]["api_os_compute_service"]
  action [:disable, :stop]
end

service "nova-scheduler" do
  service_name node["openstack"]["compute"]["platform"]["compute_scheduler_service"]
  action [:disable, :stop]
end

service "nova-conductor" do
  service_name node["openstack"]["compute"]["platform"]["compute_conductor_service"]
  action [:disable, :stop]
end

service "nova-cert" do
  service_name node["openstack"]["compute"]["platform"]["compute_cert_service"]
  action [:disable, :stop]
end

service "nova-novncproxy" do
  service_name node["openstack"]["compute"]["platform"]["compute_vncproxy_service"]
  action [:disable, :stop]
end

service "nova-consoleauth" do
  service_name node["openstack"]["compute"]["platform"]["compute_nova-consoleauth_service"]
  action [:disable, :stop]
end

service "heat-engine" do
  service_name node['openstack']['orchestration']['platform']["heat_engine_service"]
  action [:disable, :stop]
end

service "heat-api" do
  service_name node['openstack']['orchestration']['platform']["heat_api_service"]
  action [:disable, :stop]
end

service "heat-api-cfn" do
  service_name node['openstack']['orchestration']['platform']["heat_api_cfn_service"]
  action [:disable, :stop]
end

service "heat-api-cloudwatch" do
  service_name node['openstack']['orchestration']['platform']["heat_api_cloudwatch_service"]
  action [:disable, :stop]
end


remote_directory "/usr/lib/ocf/resource.d/openstack" do
  files_mode "0755"
  files_owner "root"
  mode "0755"
  owner "root"
  source "openstack"
end

