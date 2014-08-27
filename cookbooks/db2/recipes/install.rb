# encoding: UTF-8
#
# Cookbook Name:: db2
# Recipe:: install
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

db2_server 'install db2' do
  url                 node['db2']['url']
  version             node['db2']['version']
  port                node['db2']['port']
  fcm_port            node['db2']['fcm_port']
  max_logical_nodes   node['db2']['max_logical_nodes']
  instance_type       node['db2']['instance_type']
  instance_username   node['db2']['instance_username']
  instance_password   node['db2']['instance_password']
  fenced_username     node['db2']['fenced_username']
  fenced_password     node['db2']['fenced_password']
  das_username        node['db2']['das_username']
  das_password        node['db2']['das_password']
  req_packages        node['db2']['req_packages']
  download_dir        node['db2']['download_dir']
  action :install
end
