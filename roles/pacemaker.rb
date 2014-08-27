name "pacemaker"
description "Pacemaker install for OpenStack HA"
run_list(
  "role[os-base]",
  "recipe[pacemaker::install]"
)
