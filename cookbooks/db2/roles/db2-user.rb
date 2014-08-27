# encoding: UTF-8
#

name 'db2-user'
description 'create user'
run_list(
  'recipe[db2::user]'
)
