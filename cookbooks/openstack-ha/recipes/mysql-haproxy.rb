#
# Cookbook Name:: haproxy
#
# Recipe:: install
#
# Copyright 2013, IBM.
#

execute "configure-mysql-user" do
  command "mysql -uroot -p"+node["mysql"]["server_root_password"]+" -e \"grant all on *.* to root@'%' identified by '"+node["mysql"]["server_root_password"]+"' with grant option;flush privileges;\""
end

node['openstack']['ha']['nodes'].each do |hanode|
  execute "add-user-for-haproxy" do
#    command "mysql -uroot -p"+node["mysql"]["server_root_password"]+" -e \"create user 'haproxy'@'"+hanode+"'\""
    command "mysql -uroot -p"+node["mysql"]["server_root_password"]+" -e \"grant usage on *.* to 'haproxy'@'"+hanode+"'\""
  end
end

execute "configure-mysql-user" do
  command "mysql -uroot -p"+node["mysql"]["server_root_password"]+" -e \"flush privileges;\""
end

