name "pacemaker-mysql-config"
description "MySQL Galera Node configuration for haproxy"

run_list(
  "role[os-base]",
  "recipe[openstack-ha::pacemaker-mysql]",
  "recipe[openstack-ha::mysql-haproxy]"
)
