#
# Cookbook Name:: openstack-ha
# Recipe:: endpoints
#

include_recipe "openstack-ha::endpoints-#{node['openstack']['ha']['endpoints']['resource_manager']}-#{node['openstack']['ha']['endpoints']['proxy_type']}"
