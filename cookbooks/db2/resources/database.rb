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

actions :create

def initialize(*args)
  super
  @action = :create
end

attribute :db_name, kind_of: String, required: true

attribute :instance_username, kind_of: String, default: 'db2inst1', required: false
attribute :database_data_dir, kind_of: String, default: '/home/db2inst1', required: false
attribute :pagesize, kind_of: Integer, default: 16384, required: false
attribute :territory, kind_of: String, default: 'CN', required: false
