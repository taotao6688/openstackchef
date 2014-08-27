name "haproxy-ha"
description "HAProxy deployment for OpenStack HA endpoints"
run_list(
  "role[os-base]",
  "recipe[openstack-ha::haproxy-deploy]",
  "recipe[openstack-ha::pacemaker-haproxy-agent-deploy]"
)
