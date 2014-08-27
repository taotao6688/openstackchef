# encoding: UTF-8
#
# Cookbook Name:: db2
# Recipe:: user
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

db2_user 'create database user' do
  db_user node['db2']['db_user']
  db_pass node['db2']['db_pass']
  db_name node['db2']['db_name']
  instance_username node['db2']['instance_username']
  privileges node['db2']['db_privileges']
  action :create
end
