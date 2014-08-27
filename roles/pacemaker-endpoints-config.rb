name "pacemaker-endpoints-config"
description "Add resource for all services into pacemaker"
run_list(
  "role[os-base]",
  "recipe[openstack-ha::pacemaker-keystone]",
  "recipe[openstack-ha::pacemaker-glance-api]",
  "recipe[openstack-ha::pacemaker-glance-registry]",
  "recipe[openstack-ha::pacemaker-neutron-api]",
  "recipe[openstack-ha::pacemaker-neutron-dhcp]",
  "recipe[openstack-ha::pacemaker-neutron-metadata]",
  "recipe[openstack-ha::pacemaker-nova-api]",
  "recipe[openstack-ha::pacemaker-nova-scheduler]",
  "recipe[openstack-ha::pacemaker-nova-cert]",
  "recipe[openstack-ha::pacemaker-nova-novnc]",
  "recipe[openstack-ha::pacemaker-nova-conductor]",
  "recipe[openstack-ha::pacemaker-nova-consoleauth]",
  "recipe[openstack-ha::pacemaker-cinder-api]",
  "recipe[openstack-ha::pacemaker-cinder-scheduler]",
  "recipe[openstack-ha::pacemaker-cinder-volume]",
  "recipe[openstack-ha::pacemaker-heat-api]",
  "recipe[openstack-ha::pacemaker-heat-api-cfn]",
  "recipe[openstack-ha::pacemaker-heat-api-cloudwatch]",
  "recipe[openstack-ha::pacemaker-heat-engine]"
  )
