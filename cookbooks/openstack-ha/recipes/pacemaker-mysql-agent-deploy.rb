include_recipe "pacemaker::install"
require "uri"

service "mysqld" do
  service_name "mysqld"
  action [:disable]
end

cookbook_file "copy resource agent" do
    path "/usr/lib/ocf/resource.d/heartbeat/mysql2"
    source "mysql2"
    owner "root"
    group "root"
    mode "0755"
end

