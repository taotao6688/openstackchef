name "pacemaker-endpoints-deploy"
description "Add pacemaker resource agents for all endpoint services"
run_list(
  "role[os-base]",
  "recipe[openstack-ha::pacemaker-endpoints-agent-deploy]"
  )
