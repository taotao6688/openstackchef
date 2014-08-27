name "ibm-qpid-passive"
description "OpenStack HA qpid passive role"
run_list(
  "role[os-base]",
  "recipe[openstack-ha::qpid-passive]"
)
