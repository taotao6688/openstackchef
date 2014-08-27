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
action :setup do
  params = {}
  attributes = %w(db_name instance_username standby_host primary_host standby_port primary_port)
  attributes.each do |attribute|
    if new_resource.respond_to?(attribute)
      params[attribute] = new_resource.send(attribute.to_sym) unless new_resource.send(attribute.to_sym).nil?
    end
  end

  db_name = new_resource.db_name
  instance_username = new_resource.instance_username
  if instance_username.nil?
    instance_username = node['db2']['instance_username']
  end
  instance_home_dir = "/home/#{instance_username}"
  backup_dir = "#{instance_home_dir}/backup/#{db_name}"
  params['backup_dir'] = backup_dir

  directory backup_dir do
    owner instance_username
    group instance_username
    recursive true
    mode '0755'
    action :create
  end

  sql_path = "#{instance_home_dir}/primary-#{db_name}.sql"
  template sql_path do
    cookbook 'db2'
    source 'primary.sql.erb'
    owner instance_username
    group instance_username
    mode '0644'
    variables(
        'name' => new_resource.name,
        'params' => params
    )
  end

  ## need to release connections before setup HA
  ## note that the `force application all` command is asynchronous and may not be effective immediately
  execute 'release db2 connections' do
    command "su - #{instance_username} -c 'db2 force application all'; sleep 5"
  end

  execute 'setting up DB2 primary' do
    command "su - #{instance_username} -c 'db2 -v -f #{sql_path}'"

    ## the database db_name is exist and is not HA
    only_if "su - #{instance_username} -c \"(db2 'list database directory' | grep -i -w '#{db_name}') \
            && (! db2pd -hadr -db #{db_name})\""
    timeout 10000
  end

end
