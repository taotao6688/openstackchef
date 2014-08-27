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

attribute :db_user, kind_of: String, required: true
attribute :db_pass, kind_of: String, required: true
attribute :db_name, kind_of: String, required: true

attribute :instance_username, kind_of: String, required: false
attribute :privileges, kind_of: String, default: 'dbadm', required: false
