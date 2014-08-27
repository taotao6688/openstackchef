# encoding: UTF-8
#

name 'db2-primary'
description 'db2 sets primary node'
run_list(
  'role[db2-install]',
  'role[db2-database]',
  'role[db2-user]',
  'recipe[db2::primary]'
)
