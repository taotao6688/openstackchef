# encoding: UTF-8
#

name 'db2-odbc'
description 'install odbc driver'
run_list(
  'recipe[db2::odbc]'
)
