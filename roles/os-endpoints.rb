name "os-endpoints"
description "OpenStack HA endpoints role"
run_list(
  "role[os-base]",
  "recipe[openstack-ha::endpoints]"
)
