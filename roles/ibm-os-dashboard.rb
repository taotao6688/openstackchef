name "ibm-os-dashboard"
description "Horizon server"
run_list(
  "role[os-base]",
  "role[ibm-db2-driver]",
  "recipe[openstack-dashboard::server]"
)
