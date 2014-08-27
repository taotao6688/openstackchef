name "ibm-qpid-pacemaker"
description "OpenStack HA qpid role, using pacemaker"
run_list(
  "role[os-base]",
  "recipe[pacemaker::install]",
  "recipe[qpid::install]",
  "recipe[openstack-ops-messaging-ibm::pacemaker]"
)
