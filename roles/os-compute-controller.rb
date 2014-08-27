name "os-compute-controller"
description "Roll-up role for all of the OpenStack Compute services on a single, non-HA controller."
run_list(
  "role[os-base]",
  "role[os-compute-api]",
  "role[os-compute-conductor]",
  "role[os-compute-scheduler]",
  "role[os-compute-cert]",
  "role[os-compute-vncproxy]"
)
