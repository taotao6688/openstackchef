name "os-endpoints-cluster"
description "OpenStack HA endpoints role"
run_list(
  "role[os-base]",
  "recipe[openstack-ha::endpoints]"
)
