name             'openstack-compute-ibm'
maintainer       'Salman Baset'
maintainer_email 'sabaset@us.ibm.com'
license          'All rights reserved'
description      'Installs/Configures openstack-compute-ibm'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '7.0.0'

%w{ iptables qpid keepalived openstack-compute pacemaker}.each do |dep|
  depends dep
end
