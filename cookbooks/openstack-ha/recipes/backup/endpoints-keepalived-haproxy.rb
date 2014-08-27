#
# Cookbook Name:: openstack-ha
# Recipe:: endpoints-keepalived-haproxy
#

node['openstack']['endpoints'].each do |name, info|

  if info.is_a?(Hash) && info.has_key?('ha_enabled') && info['ha_enabled']

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

    ## Install and configure keepalived
    include_recipe 'keepalived::install'
    keepalived_chkscript 'chk_haproxy_status' do
      script '/sbin/service haproxy status'
      interval 5
      weight -10
      rise 1
      fall 1
      action :create
    end

    keepalived_vrrp "vi_#{info['vip'].gsub(/\./, '_')}" do
      state 'BACKUP'
      interface info['keepalived_vrrp_iface']
      virtual_router_id info['vip'].split('.')[3].to_i
      priority 100
      advert_int 1

      auth_type 'pass'
      auth_pass "^123#{info['vip'].split('.')[3]}$"

      virtual_ipaddress Array(info['vip'])

      track_script 'chk_haproxy_status'

      notify_master '/sbin/service haproxy restart'
      notify_backup '/sbin/service haproxy restart'
      notify_fault '/sbin/service haproxy restart'
      action :create
    end

  end
end
