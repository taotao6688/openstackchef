name "mysql-ha"
description "MySQL Galera Node configuration for haproxy"

run_list(
  "role[os-base]",
  "recipe[galera::server]",
  "recipe[openstack-ha::pacemaker-mysql-agent-deploy]"
)
