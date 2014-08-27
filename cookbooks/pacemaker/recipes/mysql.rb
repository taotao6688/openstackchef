include_recipe "pacemaker::install"
require "uri"

#class ::Chef::Recipe
#  include ::Openstack
#end

op_var = {"monitor" => "interval=60s timeout=120s"}

service "mysqld" do
  service_name "mysqld"
  action [:disable, :stop]
end

cookbook_file "copy resource agent" do
    path "/usr/lib/ocf/resource.d/heartbeat/mysql2"
    source "mysql2"
    owner "root"
    group "root"
    mode "0755"
end

pacemaker_agent "create mysql agent" do
    pm_resource_name "MYSQL"
    agent_name "ocf:heartbeat:mysql2"
    op_param op_var
    type "clone"
end
