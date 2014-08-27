name "qpid-ha"
description "OpenStack HA qpid role, using pacemaker"
run_list(
  "role[os-base]",
  "recipe[qpid::install]",
  "recipe[openstack-ha::pacemaker-qpid-agent-deploy]"
)
