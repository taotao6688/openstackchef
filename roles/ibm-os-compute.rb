name "ibm-os-compute"
description "The compute node, most likely with a hypervisor."
run_list(
  "role[os-base]",
  "role[ibm-db2-driver]",
  "role[os-network-openvswitch]",
  "recipe[openstack-compute::compute]"
)
