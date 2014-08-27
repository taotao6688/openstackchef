name "os-telemetry"
description "components for telemetry"
run_list(
  "role[os-base]",
  "recipe[openstack-telemetry::api]",
  "recipe[openstack-telemetry::identity_registration]",
  "recipe[openstack-telemetry::agent-central]",
  "recipe[openstack-telemetry::agent-compute]",
  "recipe[openstack-telemetry::collector]"
  )
