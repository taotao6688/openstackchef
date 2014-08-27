include_recipe "pacemaker::install"
require "uri"

class ::Chef::Recipe
  include ::Openstack
end

service "haproxy" do
  service_name "haproxy"
  action [:disable, :stop]
end

cookbook_file "copy resource agent" do
    path "/usr/lib/ocf/resource.d/heartbeat/haproxy"
    source "haproxy"
    owner "root"
    group "root"
    mode "0755"
end
