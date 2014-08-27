name             'openstack-network-ibm'
maintainer       'YOUR_COMPANY_NAME'
maintainer_email 'YOUR_EMAIL'
license          'All rights reserved'
description      'Installs/Configures openstack-network-ibm'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '7.0.0'

%w{ iptables qpid keepalived openstack-network pacemaker}.each do |dep|
  depends dep
end
