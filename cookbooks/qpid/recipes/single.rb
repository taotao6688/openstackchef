# encoding: UTF-8
#
# Cookbook Name:: qpid
# Recipe:: single
#
# =================================================================
# Licensed Materials - Property of IBM
#
# (c) Copyright IBM Corp. 2013, 2014 All Rights Reserved
#
# US Government Users Restricted Rights - Use, duplication or
# disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
# =================================================================

qpid_setup 'setup qpid' do
  port                       node['qpid']['broker']['port']
  auth                       node['qpid']['broker']['auth']
  max_connections            node['qpid']['broker']['max-connections']
  connection_backlog         node['qpid']['broker']['connection-backlog']
  worker_threads             node['qpid']['broker']['worker-threads']
  max_negotiate_time         node['qpid']['broker']['max-negotiate-time']
  link_heartbeat_interval    node['qpid']['broker']['link-heartbeat-interval']
  log_enable                 node['qpid']['broker']['log-enable']
  log_to_file                node['qpid']['broker']['log-to-file']
  ssl_port                   node['qpid']['ssl']['port']
  cert_name                  node['qpid']['ssl']['cert']['name']
  cert_db                    node['qpid']['ssl']['cert']['db']
  cert_file                  node['qpid']['ssl']['cert']['password_file']
  action :create
end
