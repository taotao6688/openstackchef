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

require 'digest/sha2'

use_inline_resources
action :create do

  db_user = new_resource.db_user
  db_pass = new_resource.db_pass
  db_name = new_resource.db_name
  db_priv = new_resource.privileges
  instance_username = new_resource.instance_username
  if instance_username.nil?
    instance_username = node['db2']['instance_username']
  end

  if db_user.length > 8
    puts ''
    puts '==========================================='
    puts 'database user should less than 8 characters'
    puts '==========================================='
    exit(1)
  end

  shadow = db_pass.crypt('$6$' + rand(36**8).to_s(36))
  user "create database user(#{db_user})" do
    username db_user
    password shadow
    supports manage_home: true
    action :create
  end

  execute "grant privilege to user(#{db_user}) on database(#{db_name})" do
    command "su - #{instance_username} -c \"(db2 'connect to #{db_name}') \
            && (db2 'grant #{db_priv} on database to user #{db_user}') && (db2 'connect reset')\""

    ## the database db_name is exist and is not standby
    only_if "su - #{instance_username} -c \"(db2 'list database directory' | grep -i -w '#{db_name}') \
            && (! db2pd -hadr -db #{db_name} | grep -w -q 'HADR_ROLE = STANDBY')\""
    ## don't grant if already did
    not_if "su - #{instance_username} -c \"db2 'connect to #{db_name}' \
            && db2 \\\"SELECT DISTINCT GRANTEE FROM SYSCAT.DBAUTH WHERE DBADMAUTH = 'Y' AND GRANTEE = '#{db_user.upcase}'\\\"\""
  end

end
