# encoding: UTF-8
#
# Cookbook Name:: db2
# Recipe:: database
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

db2_database 'create database' do
  db_name node['db2']['db_name']
  pagesize node['db2']['db_pagesize']
  territory node['db2']['db_territory']
  database_data_dir node['db2']['database_data_dir']
  instance_username node['db2']['instance_username']
  action :create
end
