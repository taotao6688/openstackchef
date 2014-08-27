include_recipe "pacemaker::install"
require "uri"

class ::Chef::Recipe
  include ::Openstack
end

platform_options = node["openstack"]["block-storage"]["platform"]
mq_port = node["openstack"]["endpoints"]["mq"]["port"]

op_var = {"monitor" => "interval=20s timeout=20s"}
api_var = {
            "config" => "/etc/cinder/cinder.conf",
            "amqp_server_port" => mq_port,
            }

service "cinder-volume" do
  service_name platform_options["cinder_volume_service"]
  action [:disable, :stop]
end

cookbook_file "copy cinder-volume resource agent" do
    path "/usr/lib/ocf/resource.d/openstack/cinder-volume"
    source "cinder-volume"
    owner "root"
    group "root"
    mode "0755"
end

pacemaker_agent "create cinder-volume agent" do
    pm_resource_name "CINDER_VOLUME"
    agent_name "ocf:openstack:cinder-volume"
    op_param op_var
    params api_var
    type "clone"
end
