name             'openstack-identity-ibm'
maintainer       'YOUR_COMPANY_NAME'
maintainer_email 'YOUR_EMAIL'
license          'All rights reserved'
description      'Installs/Configures openstack-identity-ibm'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '7.0.0'
%w{ iptables keepalived openstack-identity pacemaker}.each do |dep|
  depends dep
end
