name "mysql"
description "MySQL Galera Node configuration for haproxy"

run_list(
  "role[os-base]",
  "recipe[galera::server]"
)
