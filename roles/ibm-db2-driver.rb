name "ibm-db2-driver"
description "IBM DB2 odbc driver"
run_list(
  "role[os-base]",
  "recipe[openstack-ops-database::db2-client]"
)
