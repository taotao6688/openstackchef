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
  primary_host = new_resource.primary_host
  instance_username = new_resource.instance_username
  if instance_username.nil?
    instance_username = node['db2']['instance_username']
  end
  instance_password = new_resource.instance_password
  if instance_password.nil?
    instance_password = node['db2']['instance_password']
  end
  instance_home_dir = "/home/#{instance_username}"
  backup_dir = "#{instance_home_dir}/backup"
  params['backup_dir'] = "#{backup_dir}/#{db_name}"

  package 'install sshpass for copying DB2 backup data' do
    package_name 'sshpass'
    action :install
  end

  execute 'delete-remote-backup_dir' do
    command "sshpass -p#{instance_password} ssh -o StrictHostKeyChecking=no \
            #{instance_username}@#{primary_host} 'rm -rf #{backup_dir}'"
    action :nothing
  end

  execute 'copy backup database file from Primary' do
    command "su - #{instance_username} -c 'sshpass -p#{instance_password} scp -r -o StrictHostKeyChecking=no #{instance_username}@#{primary_host}:#{backup_dir} ~'"
    not_if "su - #{instance_username} -c 'db2pd -db #{db_name} -hadr | grep -q \"HADR_ROLE = STANDBY\"'"
    timeout 10000
  end

  sql_path = "#{instance_home_dir}/standby-#{db_name}.sql"
  template sql_path do
    cookbook 'db2'
    source 'standby.sql.erb'
    owner instance_username
    group instance_username
    mode '0644'
    variables(
        'name' => new_resource.name,
        'params' => params
    )
    # notifies :run, 'execute[delete-remote-backup_dir]', :delayed
  end

  ## need to release connections before setup HA
  ## note that the `force application all` command is asynchronous and may not be effective immediately
  execute 'release db2 connections' do
    command "su - #{instance_username} -c 'db2 force application all'; sleep 5"
  end

  execute 'setting up DB2 standby' do
    command "su - #{instance_username} -c 'db2 -v -f #{sql_path}'"
    returns [0, 2]

    ## DB2 database db_name is exist
    not_if "su - #{instance_username} -c 'db2pd -db #{db_name} -hadr | grep -q \"HADR_ROLE = STANDBY\"'"
    timeout 10000
  end

end
