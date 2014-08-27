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

require 'mixlib/shellout'

## TODO: move this to db2_database as an option
use_inline_resources
action :enable do

  database_username = new_resource.database_username
  database_name = new_resource.database_name
  database_host = new_resource.database_host
  database_port = new_resource.database_port
  database_user_password = new_resource.database_user_password
  database_mongo_port = new_resource.database_mongo_port
  instance_username = new_resource.instance_username
  if instance_username.nil?
    instance_username = node['db2']['instance_username']
  end

  db2_dir = Mixlib::ShellOut.new("db2ls | awk '{print $1}' | grep ^/").run_command.stdout.strip
  jdk_dir_name = Mixlib::ShellOut.new("ls \"#{db2_dir}\"/java | grep jdk").run_command.stdout.strip
  java_home = "#{db2_dir}/java/#{jdk_dir_name}"
  json_log_path = "/home/#{instance_username}/json/logs"

  directory "/home/#{instance_username}/json" do
    owner instance_username
    group instance_username
    mode 00775

    action :create
  end

  directory json_log_path do
    owner instance_username
    group instance_username
    mode 00775
    action :create
  end

  execute "Add databaser user #{database_username} to db2 instance group" do
    command "usermod -G `id #{instance_username} | awk '{print $2}' | cut -d '=' -f 2 | cut -d '(' -f 1` #{database_username}"
    action :run
  end

  bash "Enable NoSQL for database #{database_name} and user #{database_username} on DB2" do
    code <<-EOH
      usermod -G `id "#{instance_username}" | awk '{print $2}' | cut -d '=' -f 2 | cut -d '(' -f 1` "#{database_username}"
      su - "#{instance_username}" -c "cd #{db2_dir}/json/bin && ./db2nosql.sh -user #{database_username} -hostName #{database_host} -port #{database_port} -db #{database_name} -setup enable -password #{database_user_password}"
      su - "#{instance_username}" -c "export JAVA_HOME=#{java_home} && cd #{db2_dir}/json/bin && nohup ./wplistener.sh -start -logPath #{json_log_path} -mongoPort #{database_mongo_port} -userid #{database_username} -password #{database_user_password} -dbName #{database_name} 2>&1 &"
      EOH
  end

  template '/etc/rc.d/init.d/db2.nosql.service' do
    cookbook 'db2'
    source 'db2.nosql.service.erb'
    owner 'root'
    group 'root'
    mode '0755'
    variables(
      'instance_username' => instance_username,
      'java_home' => java_home,
      'db2_dir' => db2_dir,
      'database_mongo_port' => database_mongo_port,
      'database_username' => database_username,
      'database_user_password' => database_user_password,
      'database_name' => database_name,
      'noSQLHost' => database_host,
      'logPath' => json_log_path
    )
  end

  service 'db2.nosql.service' do
    action :enable
  end

end
