name "os-network"
description "Configures OpenStack networking, managed by attribute for either nova-network or neutron."
run_list(
  "role[os-base]",
  "role[os-network-openvswitch]",
  "role[os-network-dhcp-agent]",
  "role[os-network-metadata-agent]",
  "role[os-network-server]",
  "recipe[openstack-network::identity_registration]"
  )
