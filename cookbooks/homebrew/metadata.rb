name             'homebrew'
maintainer       'IBM'
maintainer_email 'zhiwchen@cn.ibm.com'
license          'All rights reserved'
description      'Installs/Configures db2'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

%w{ fedora redhat centos }.each do |os|
  supports os
end
