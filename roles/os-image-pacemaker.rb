name 'os-image-pacemaker'
description 'Roll-up role for Glance.'
run_list(
  'role[os-image-api]',
  'role[os-image-registry]',
  'recipe[openstack-image::identity_registration]',
  'recipe[openstack-image-ibm::pacemaker-api]',
  'recipe[openstack-image-ibm::pacemaker-registry]'
  )
