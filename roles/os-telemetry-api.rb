name "os-telemetry-api"
description "api for telemetry"
run_list(
  "role[os-base]",
  "recipe[openstack-telemetry::api]",
  "recipe[openstack-telemetry::identity_registration]"
  )
