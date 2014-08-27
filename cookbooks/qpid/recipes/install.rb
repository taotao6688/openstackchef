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

qpid_ha_setup "setup qpid active" do

  ha_public_url   node['openstack']['mq']['qpid']['vip']
  ha_brokers_url  node['openstack']['mq']['qpid']['nodes']

  action :create

end

