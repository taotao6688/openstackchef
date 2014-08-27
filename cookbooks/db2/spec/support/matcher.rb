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

def create_db2_database(name)
  ChefSpec::Matchers::ResourceMatcher.new(:db2_database, :create, name)
end

def install_db2_server(name)
  ChefSpec::Matchers::ResourceMatcher.new(:db2_server, :install, name)
end

def install_db2_odbc(name)
  ChefSpec::Matchers::ResourceMatcher.new(:db2_odbc, :install, name)
end

def setup_db2_primary(name)
  ChefSpec::Matchers::ResourceMatcher.new(:db2_primary, :setup, name)
end

def setup_db2_standby(name)
  ChefSpec::Matchers::ResourceMatcher.new(:db2_standby, :setup, name)
end

def create_db2_user(name)
  ChefSpec::Matchers::ResourceMatcher.new(:db2_user, :create, name)
end
