name "os-block-storage-pacemaker"
description "Configures OpenStack block storage, configured by attributes."
run_list(
  "role[os-base]",
  "role[os-block-storage-api]",
  "role[os-block-storage-scheduler]",
  "recipe[openstack-block-storage::identity_registration]",
  "recipe[openstack-block-storage-ibm::pacemaker-api]",
  "recipe[openstack-block-storage-ibm::pacemaker-scheduler]"
  )
