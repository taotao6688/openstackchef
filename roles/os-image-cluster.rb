name 'os-image-cluster'
description 'Roll-up role for Glance.'
run_list(
  'role[os-image-api]',
  'role[os-image-registry]',
  'recipe[openstack-image::identity_registration]'
  )
