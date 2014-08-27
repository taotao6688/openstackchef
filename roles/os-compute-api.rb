name "os-compute-api"
description "Roll-up role for all the Compute APIs"
run_list(
  "role[os-base]",
  "role[os-compute-api-ec2]",
  "role[os-compute-api-os-compute]",
  "role[os-compute-api-metadata]",
  "recipe[openstack-compute::identity_registration]"
  )
