# encoding: UTF-8
#
# =================================================================
# Licensed Materials - Property of IBM
#
# (c) Copyright IBM Corp. 2014 All Rights Reserved
#
# US Government Users Restricted Rights - Use, duplication or
# disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
# =================================================================
#

use_inline_resources
action :create do

  db_name = new_resource.db_name
  pagesize = new_resource.pagesize
  territory = new_resource.territory
  data_dir = new_resource.database_data_dir
  instance_username = new_resource.instance_username
  if instance_username.nil?
    instance_username = node['db2']['instance_username']
  end
  instance_home_dir = "/home/#{instance_username}"

  if db_name.length > 8
    puts ''
    puts '==========================================='
    puts 'database name should less than 8 characters'
    puts '==========================================='
    exit(1)
  end

  ## Create data dir
  directory data_dir do
    owner instance_username
    group instance_username
    mode '0755'
    recursive true
    action :create
  end

  execute "create database(#{db_name})" do
    command "su - #{instance_username} -c \"db2 'create database #{db_name} AUTOMATIC STORAGE YES ON \\\"#{data_dir}\\\" DBPATH ON \\\"#{instance_home_dir}\\\" USING CODESET UTF-8 TERRITORY #{territory} COLLATE USING SYSTEM PAGESIZE #{pagesize}'\""

    ## the database db_name is not exist and is not standby
    only_if "su - #{instance_username} -c \"(! db2 'list database directory' | grep -i -w '#{db_name}') \
           && (! db2pd -hadr -db #{db_name} | grep -w -q 'HADR_ROLE = STANDBY')\""

    timeout 10000
  end

end
