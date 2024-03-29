# encoding: UTF-8

#
# Cookbook Name:: openstack-common
# library:: default
#
# Copyright 2012-2013, AT&T Services, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

module ::Openstack # rubocop:disable Documentation
  # Library routine that uses the database cookbook to create the
  # service's database and grant read/write access to the
  # given user and password.
  #
  # A privileged 'super user' and password is determined from the
  # underlying database cookbooks. For instance, if a MySQL database
  # is used, the node['mysql']['server_root_password'] is used along
  # with the 'root' (super)user.
  def db_create_with_user(service, user, pass) # rubocop:disable CyclomaticComplexity, MethodLength
    root_user_use_databag = node['openstack']['db']['root_user_use_databag']
    info = db service
    if info
      host = info['host']
      port = info['port'].to_s
      type = info['service_type']
      db_name = info['db_name']
      case type
      when 'postgresql', 'pgsql'
        include_recipe 'database::postgresql'
        db_prov = ::Chef::Provider::Database::Postgresql
        user_prov = ::Chef::Provider::Database::PostgresqlUser
        super_user = 'postgres'
        if root_user_use_databag
          user_key = node['openstack']['db']['root_user_key']
          super_password = get_password 'user', user_key
        else
          super_password = node['postgresql']['password']['postgres']
        end
      when 'mysql'

        super_user = 'root'
        if root_user_use_databag
          user_key = node['openstack']['db']['root_user_key']
          super_password = get_password 'user', user_key
        else
          super_password = node['mysql']['server_root_password']
        end

        sql_connect = "mysql -P #{port} -u #{super_user} -p#{super_password}"
        # sql_connect = "mysql -h #{host} -P #{port} -u #{super_user} -p#{super_password}"
        sql_create = "CREATE DATABASE IF NOT EXISTS #{db_name} DEFAULT CHARACTER SET utf8"
        sql_grant = "GRANT ALL ON #{db_name}.* TO '#{user}'@'%' IDENTIFIED BY '#{pass}'"

        execute "create database(#{db_name}) on #{host}" do
          command "#{sql_connect} -e \"#{sql_create}\""
        end

        execute "grant user(#{user}) to database(#{db_name}) on #{host}" do
          command "#{sql_connect} -e \"#{sql_grant}\""
        end

        return info
      when 'db2'
        return info
      else
        ::Chef::Log.error("Unsupported database type #{type}")
      end

      connection_info = {
        host: host,
        port: port.to_i,
        username: super_user,
        password: super_password
      }

      # create database
      database "create #{db_name} database" do
        provider db_prov
        connection connection_info
        database_name db_name
        action :create
      end

      # create user
      database_user user do
        provider user_prov
        connection connection_info
        password pass
        action :create
      end

      # grant privs to user
      database_user user do
        provider user_prov
        connection connection_info
        password pass
        database_name db_name
        host '%'
        privileges [:all]
        action :grant
      end
    end
    info
  end
end
