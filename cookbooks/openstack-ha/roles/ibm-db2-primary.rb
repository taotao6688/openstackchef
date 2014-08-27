name "ibm-db2-primary"
description "OpenStack HA db2 primary role"
run_list(
  "role[os-base]",
  "recipe[openstack-ha::db2-primary]"
)
