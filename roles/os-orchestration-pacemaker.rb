name "os-orchestration-pacemaker"
description "Role for Heat HA, using pacemaker."
run_list(
  "recipe[openstack-orchestration-ibm::pacemaker-heat-engine]",
  "recipe[openstack-orchestration-ibm::pacemaker-heat-api]",
  "recipe[openstack-orchestration-ibm::pacemaker-heat-api-cfn]",
  "recipe[openstack-orchestration-ibm::pacemaker-heat-api-cloudwatch]"
  )
