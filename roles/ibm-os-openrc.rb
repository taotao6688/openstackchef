name "ibm-os-openrc"
description "OpenStack openrc role"
run_list(
  "recipe[openstack-common::openrc]"
)
