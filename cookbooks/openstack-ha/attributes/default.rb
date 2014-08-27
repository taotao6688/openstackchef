# encoding: UTF-8
#
# Cookbook Name:: openstack-ha
# Attribute:: default
#

## General HA configuration
default['openstack']['ha']['enabled'] = true
default['openstack']['ha']['resource_manager'] = 'keepalived'
## If using keepalived, you need to set `keepalived_vrrp_iface`
default['openstack']['ha']['keepalived_vrrp_iface'] = 'eth0'

## Database HA
default['openstack']['db']['db2']['vip'] = nil
default['openstack']['db']['db2']['db_name'] = 'openstac'
default['openstack']['db']['db2']['ha_enabled'] = node['openstack']['ha']['enabled']
default['openstack']['db']['db2']['resource_manager'] = node['openstack']['ha']['resource_manager']
default['openstack']['db']['db2']['keepalived_vrrp_iface'] = node['openstack']['ha']['keepalived_vrrp_iface']
default['openstack']['db']['db2']['primary_host'] = nil
default['openstack']['db']['db2']['primary_port'] = 10000
default['openstack']['db']['db2']['standby_host'] = nil
default['openstack']['db']['db2']['standby_port'] = 10000

## Message Queue HA
default['openstack']['mq']['qpid']['vip'] = nil
default['openstack']['mq']['qpid']['ha_enabled'] = node['openstack']['ha']['enabled']
default['openstack']['mq']['qpid']['resource_manager'] = node['openstack']['ha']['resource_manager']
default['openstack']['mq']['qpid']['keepalived_vrrp_iface'] = node['openstack']['ha']['keepalived_vrrp_iface']
default['openstack']['mq']['qpid']['nodes'] = ['127.0.0.1', '127.0.0.2']

## OpenStack Endpoints HA
default['openstack']['ha']['endpoints']['vip'] = nil
default['openstack']['ha']['endpoints']['enabled'] = node['openstack']['ha']['enabled']
default['openstack']['ha']['endpoints']['resource_manager'] = node['openstack']['ha']['resource_manager']
default['openstack']['ha']['endpoints']['proxy_type'] = 'haproxy'
default['openstack']['ha']['endpoints']['keepalived_vrrp_iface'] = node['openstack']['ha']['keepalived_vrrp_iface']

default['openstack']['endpoints']['identity-api']['vip'] = node['openstack']['ha']['endpoints']['vip']
default['openstack']['endpoints']['identity-api']['ha_enabled'] = node['openstack']['ha']['endpoints']['enabled']
default['openstack']['endpoints']['identity-api']['nodes'] = ['127.0.0.1', '127.0.0.2']
default['openstack']['endpoints']['identity-api']['keepalived_vrrp_iface'] = node['openstack']['ha']['endpoints']['keepalived_vrrp_iface']

default['openstack']['endpoints']['identity-admin']['vip'] = node['openstack']['ha']['endpoints']['vip']
default['openstack']['endpoints']['identity-admin']['ha_enabled'] = node['openstack']['ha']['endpoints']['enabled']
default['openstack']['endpoints']['identity-admin']['nodes'] = ['127.0.0.1', '127.0.0.2']
default['openstack']['endpoints']['identity-admin']['keepalived_vrrp_iface'] = node['openstack']['ha']['endpoints']['keepalived_vrrp_iface']

default['openstack']['endpoints']['compute-api']['vip'] = node['openstack']['ha']['endpoints']['vip']
default['openstack']['endpoints']['compute-api']['ha_enabled'] = node['openstack']['ha']['endpoints']['enabled']
default['openstack']['endpoints']['compute-api']['keepalived_vrrp_iface'] = node['openstack']['ha']['endpoints']['keepalived_vrrp_iface']
default['openstack']['endpoints']['compute-api']['nodes'] = ['127.0.0.1', '127.0.0.2']

default['openstack']['endpoints']['compute-ec2-api']['vip'] = node['openstack']['ha']['endpoints']['vip']
default['openstack']['endpoints']['compute-ec2-api']['ha_enabled'] = node['openstack']['ha']['endpoints']['enabled']
default['openstack']['endpoints']['compute-ec2-api']['nodes'] = ['127.0.0.1', '127.0.0.2']
default['openstack']['endpoints']['compute-ec2-api']['keepalived_vrrp_iface'] = node['openstack']['ha']['endpoints']['keepalived_vrrp_iface']

default['openstack']['endpoints']['compute-ec2-admin']['vip'] = node['openstack']['ha']['endpoints']['vip']
default['openstack']['endpoints']['compute-ec2-admin']['ha_enabled'] = node['openstack']['ha']['endpoints']['enabled']
default['openstack']['endpoints']['compute-ec2-admin']['nodes'] = ['127.0.0.1', '127.0.0.2']
default['openstack']['endpoints']['compute-ec2-admin']['keepalived_vrrp_iface'] = node['openstack']['ha']['endpoints']['keepalived_vrrp_iface']

default['openstack']['endpoints']['compute-xvpvnc']['vip'] = node['openstack']['ha']['endpoints']['vip']
default['openstack']['endpoints']['compute-xvpvnc']['ha_enabled'] = node['openstack']['ha']['endpoints']['enabled']
default['openstack']['endpoints']['compute-xvpvnc']['nodes'] = ['127.0.0.1', '127.0.0.2']
default['openstack']['endpoints']['compute-xvpvnc']['keepalived_vrrp_iface'] = node['openstack']['ha']['endpoints']['keepalived_vrrp_iface']

default['openstack']['endpoints']['compute-novnc']['vip'] = node['openstack']['ha']['endpoints']['vip']
default['openstack']['endpoints']['compute-novnc']['ha_enabled'] = node['openstack']['ha']['endpoints']['enabled']
default['openstack']['endpoints']['compute-novnc']['nodes'] = ['127.0.0.1', '127.0.0.2']
default['openstack']['endpoints']['compute-novnc']['keepalived_vrrp_iface'] = node['openstack']['ha']['endpoints']['keepalived_vrrp_iface']

default['openstack']['endpoints']['network-api']['vip'] = node['openstack']['ha']['endpoints']['vip']
default['openstack']['endpoints']['network-api']['ha_enabled'] = node['openstack']['ha']['endpoints']['enabled']
default['openstack']['endpoints']['network-api']['nodes'] = ['127.0.0.1', '127.0.0.2']
default['openstack']['endpoints']['network-api']['keepalived_vrrp_iface'] = node['openstack']['ha']['endpoints']['keepalived_vrrp_iface']

default['openstack']['endpoints']['image-api']['vip'] = node['openstack']['ha']['endpoints']['vip']
default['openstack']['endpoints']['image-api']['ha_enabled'] = node['openstack']['ha']['endpoints']['enabled']
default['openstack']['endpoints']['image-api']['nodes'] = ['127.0.0.1', '127.0.0.2']
default['openstack']['endpoints']['image-api']['keepalived_vrrp_iface'] = node['openstack']['ha']['endpoints']['keepalived_vrrp_iface']

default['openstack']['endpoints']['image-registry']['vip'] = node['openstack']['ha']['endpoints']['vip']
default['openstack']['endpoints']['image-registry']['ha_enabled'] = node['openstack']['ha']['endpoints']['enabled']
default['openstack']['endpoints']['image-registry']['nodes'] = ['127.0.0.1', '127.0.0.2']
default['openstack']['endpoints']['image-registry']['keepalived_vrrp_iface'] = node['openstack']['ha']['endpoints']['keepalived_vrrp_iface']

default['openstack']['endpoints']['block-storage-api']['vip'] = node['openstack']['ha']['endpoints']['vip']
default['openstack']['endpoints']['block-storage-api']['ha_enabled'] = node['openstack']['ha']['endpoints']['enabled']
default['openstack']['endpoints']['block-storage-api']['nodes'] = ['127.0.0.1', '127.0.0.2']
default['openstack']['endpoints']['block-storage-api']['keepalived_vrrp_iface'] = node['openstack']['ha']['endpoints']['keepalived_vrrp_iface']

default['openstack']['endpoints']['object-storage-api']['vip'] = node['openstack']['ha']['endpoints']['vip']
default['openstack']['endpoints']['object-storage-api']['ha_enabled'] = node['openstack']['ha']['endpoints']['enabled']
default['openstack']['endpoints']['object-storage-api']['nodes'] = ['127.0.0.1', '127.0.0.2']
default['openstack']['endpoints']['object-storage-api']['keepalived_vrrp_iface'] = node['openstack']['ha']['endpoints']['keepalived_vrrp_iface']

default['openstack']['endpoints']['telemetry-api']['vip'] = node['openstack']['ha']['endpoints']['vip']
default['openstack']['endpoints']['telemetry-api']['ha_enabled'] = node['openstack']['ha']['endpoints']['enabled']
default['openstack']['endpoints']['telemetry-api']['nodes'] = ['127.0.0.1', '127.0.0.2']
default['openstack']['endpoints']['telemetry-api']['keepalived_vrrp_iface'] = node['openstack']['ha']['endpoints']['keepalived_vrrp_iface']

default['openstack']['endpoints']['orchestration-api']['vip'] = node['openstack']['ha']['endpoints']['vip']
default['openstack']['endpoints']['orchestration-api']['ha_enabled'] = node['openstack']['ha']['endpoints']['enabled']
default['openstack']['endpoints']['orchestration-api']['nodes'] = ['127.0.0.1', '127.0.0.2']
default['openstack']['endpoints']['orchestration-api']['keepalived_vrrp_iface'] = node['openstack']['ha']['endpoints']['keepalived_vrrp_iface']

default['openstack']['endpoints']['orchestration-api-cfn']['vip'] = node['openstack']['ha']['endpoints']['vip']
default['openstack']['endpoints']['orchestration-api-cfn']['ha_enabled'] = node['openstack']['ha']['endpoints']['enabled']
default['openstack']['endpoints']['orchestration-api-cfn']['nodes'] = ['127.0.0.1', '127.0.0.2']
default['openstack']['endpoints']['orchestration-api-cfn']['keepalived_vrrp_iface'] = node['openstack']['ha']['endpoints']['keepalived_vrrp_iface']

default['openstack']['endpoints']['orchestration-api-cloudwatch']['vip'] = node['openstack']['ha']['endpoints']['vip']
default['openstack']['endpoints']['orchestration-api-cloudwatch']['ha_enabled'] = node['openstack']['ha']['endpoints']['enabled']
default['openstack']['endpoints']['orchestration-api-cloudwatch']['nodes'] = ['127.0.0.1', '127.0.0.2']
default['openstack']['endpoints']['orchestration-api-cloudwatch']['keepalived_vrrp_iface'] = node['openstack']['ha']['endpoints']['keepalived_vrrp_iface']
