name "os-endpoints-pacemaker"
description "OpenStack HA endpoints role"
run_list(
  "role[os-base]",
  "recipe[openstack-ha::haproxy-deploy]",
  "recipe[openstack-ha::pacemaker-haproxy]"
)
