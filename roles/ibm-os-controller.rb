name "ibm-os-controller"
description "Roll-up role for all of the OpenStack controller services on a single, non-HA controller."
run_list(
  "role[os-base]",
  "role[ibm-db2-driver]",
  "role[os-identity]",
  "role[os-image]",
  "role[os-block-storage]",
  "role[os-network-server]",
  "role[os-compute-setup]",
  "role[os-compute-api]",
  "role[os-compute-conductor]",
  "role[os-compute-scheduler]",
  "role[os-compute-cert]",
  "role[os-compute-vncproxy]"
)
