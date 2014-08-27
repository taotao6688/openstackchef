name             'openstack-image-ibm'
maintainer       'YOUR_COMPANY_NAME'
maintainer_email 'YOUR_EMAIL'
license          'All rights reserved'
description      'Installs/Configures openstack-image-ibm'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '7.0.0'
%w{ iptables keepalived openstack-image pacemaker}.each do |dep|
  depends dep
end
