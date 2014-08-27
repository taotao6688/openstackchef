name "ibm-db2-standby"
description "OpenStack HA db2 standby role"
run_list(
  "role[os-base]",
  "recipe[openstack-ha::db2-standby]"
)
