name "cc_galera"
description "MySQL Galera Node"

run_list(
  "role[os-base]",
  "recipe[galera::server]"
)
