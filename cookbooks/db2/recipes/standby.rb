# encoding: UTF-8
#
# Cookbook Name:: db2
# Recipe:: standby
#
# =================================================================
# Licensed Materials - Property of IBM
#
# (c) Copyright IBM Corp. 2014 All Rights Reserved
#
# US Government Users Restricted Rights - Use, duplication or
# disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
# =================================================================
#

db2_standby 'setup DB2 standby' do
  db_name      node['db2']['db_name']
  primary_host node['db2']['primary_host']
  primary_port node['db2']['primary_port']
  standby_host node['db2']['standby_host']
  standby_port node['db2']['standby_port']
  instance_username node['db2']['instance_username']
  instance_password node['db2']['instance_password']
  action :setup
end
