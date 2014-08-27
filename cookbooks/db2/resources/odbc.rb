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

actions :install

def initialize(*args)
  super
  @action = :install
end

attribute :url, kind_of: String, required: true
attribute :install_dir, kind_of: String, default: '/opt/ibm/db2', required: false
attribute :download_dir, kind_of: String, default: '/tmp', required: false
