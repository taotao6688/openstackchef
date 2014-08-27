name "os-compute-pacemaker"
description "Nova setup and identity registration"
run_list(
  "role[os-base]",
  "recipe[openstack-compute::nova-setup]",
  "recipe[openstack-compute::identity_registration]",
  "recipe[openstack-compute-ibm::pacemaker-api]",
  "recipe[openstack-compute-ibm::pacemaker-conductor]",
  "recipe[openstack-compute-ibm::pacemaker-scheduler]",
  "recipe[openstack-compute-ibm::pacemaker-cert]",
  "recipe[openstack-compute-ibm::pacemaker-consoleauth]",
  "recipe[openstack-compute-ibm::pacemaker-novnc]"
  )
