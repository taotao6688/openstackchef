name "pacemaker-qpid-config"
description "Add resource for QPID into pacemaker"
run_list(
  "role[os-base]",
  "recipe[openstack-ha::pacemaker-qpid]"
  )
