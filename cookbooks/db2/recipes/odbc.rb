# encoding: UTF-8
#
# Cookbook Name:: db2
# Recipe:: odbc
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

db2_odbc 'install odbc driver' do
  url                 node['db2']['odbc_url']
  download_dir        node['db2']['download_dir']
  action :install
end
