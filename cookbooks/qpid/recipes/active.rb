# encoding: UTF-8
#
# Cookbook Name:: qpid
# Recipe:: active
#
# =================================================================
# Licensed Materials - Property of IBM
#
# (c) Copyright IBM Corp. 2013, 2014 All Rights Reserved
#
# US Government Users Restricted Rights - Use, duplication or
# disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
# =================================================================

qpid_ha_setup 'setup qpid active' do
  port    node['qpid']['broker']['port']
  auth    node['qpid']['broker']['auth']

  ha_public_url   node['qpid']['ha']['vip']
  ha_brokers_url  node['qpid']['ha']['brokers_url']
  ha_replicate    node['qpid']['ha']['replicate']
  ha_mechanism    node['qpid']['ha']['mechanism']
  ha_username     node['qpid']['ha']['username']
  ha_password     node['qpid']['ha']['password']
  ha_backup_timeout node['qpid']['ha']['backup_timeout']

  action :create
end
