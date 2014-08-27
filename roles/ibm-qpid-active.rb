name "ibm-qpid-active"
description "OpenStack HA qpid active role"
run_list(
  "role[os-base]",
  "recipe[openstack-ha::qpid-active]"
)
