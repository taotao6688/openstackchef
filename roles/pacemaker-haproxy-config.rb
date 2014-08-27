name "pacemaker-haproxy-config"
description "HAProxy deployment for OpenStack HA endpoints"
run_list(
  "role[os-base]",
  "recipe[openstack-ha::pacemaker-haproxy]"
)
