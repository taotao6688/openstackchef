# encoding: UTF-8
#

name 'db2-database'
description 'db2 creates database'
run_list(
  'recipe[db2::database]'
)
