# encoding: UTF-8
#
# Cookbook Name:: yum
# Recipe:: ibm
#

node['yum']['repo'].each do |repo|
  if repo['url'].length == 0 || repo['name'].length == 0
    next
  end
  yum_repository "IBM-#{repo['name']}" do
    repositoryid repo['name']
    description repo['name']
    url repo['url']
    enabled true
    gpgcheck false
    sslverify false
    action :nothing
  end.run_action(:add)
end
