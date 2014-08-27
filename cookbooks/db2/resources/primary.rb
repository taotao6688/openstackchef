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

actions :setup

def initialize(*args)
  super
  @action = :setup
end

attribute :db_name, kind_of: String, required: true
attribute :primary_host, kind_of: String, required: true
attribute :primary_port, kind_of: Integer, required: true
attribute :standby_host, kind_of: String, required: true
attribute :standby_port, kind_of: Integer, required: true
attribute :instance_username, kind_of: String, default: 'db2inst1', required: false
