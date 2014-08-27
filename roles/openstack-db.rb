name "openstack-db"
description "Currently MySQL Server (galera-ha)"
run_list(
  "role[os-base]",
  "recipe[openstack-ops-database::openstack-db]"
)
