#
# Cookbook Name:: stingray
# Recipe:: join_cluster
#
# Copyright 2013, IBM
#
# All rights reserved - Do Not Redistribute
#

if node["iptables"]["enabled"] == true
    iptables_rule "port_stingray"
end

stingray "stingray" do
    url node['stingray']['url']
    action :install
end

stingray_join_cluster "join_cluster" do
    cluster_host node['stingray']['cluster_host']
    password node['stingray']['password']
end
