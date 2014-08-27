name "ibm-os-block-storage-volume"
description "OpenStack Block Storage volume service"
run_list(
  "role[os-base]",
  "role[ibm-db2-driver]",
  "recipe[openstack-block-storage::volume]"
)
