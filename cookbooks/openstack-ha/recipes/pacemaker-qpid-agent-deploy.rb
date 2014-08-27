include_recipe "pacemaker::install"
require "uri"

class ::Chef::Recipe
  include ::Openstack
end

service "qpid" do
  service_name "qpidd"
  action [:disable, :stop]
end

cookbook_file "copy resource agent" do
    path "/usr/lib/ocf/resource.d/openstack/qpidd"
    source "openstack/qpidd"
    owner "root"
    group "root"
    mode "0755"
end

