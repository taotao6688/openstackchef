#
# Cookbook Name:: openstack-ha
# Recipe:: endpoints-pacemaker-haproxy
#

node['openstack']['endpoints'].each do |name, info|

  if info.is_a?(Hash) && info.has_key?('ha_enabled') && info['ha_enabled']
    if name == "db"
      ## Install and configure haproxy for mysql
      include_recipe 'haproxy::install'
      haproxy_virtual_server name do
        lb_algo 'source'
        mode 'tcp'
        options ['tcpka', 'mysql-check user haproxy']
        vs_listen_ip '0.0.0.0'
        vs_listen_port info['port']
        real_servers info['nodes']
      end
    else
      ## Install and configure haproxy
      include_recipe 'haproxy::install'
      haproxy_virtual_server name do
        lb_algo 'roundrobin'
        mode 'http'
        options ['forwardfor', 'httplog']
        vs_listen_ip '0.0.0.0'
        vs_listen_port info['port']
        real_servers info['nodes']
      end
    end
  end
end
