maintainer        "Rackspace US, Inc."
license           "Apache 2.0"
description       "Installs and configures haproxy for use in an Openstack deployment"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           "1.0.6"

%w{ centos ubuntu }.each do |os|
  supports os
end

#%w{ apt monitoring openssl osops-utils yum }.each do |dep|
#%w{ apt osops-utils yum }.each do |dep|
%w{ apt }.each do |dep|
  depends dep
end
