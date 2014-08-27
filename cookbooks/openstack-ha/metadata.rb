maintainer       "IBM"
maintainer_email "zhiwchen@cn.ibm.com"
license          "All rights reserved"
description      "Installs/Configures OpenStack HA components"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           "9.0.0"

%w{ centos redhat }.each do |os|
  supports os
end

%w{ haproxy keepalived pacemaker openstack-common openstack-ops-database openstack-ops-messaging openstack-identity openstack-image openstack-network openstack-block-storage openstack-compute openstack-orchestration}.each do |dep|
  depends dep
end
