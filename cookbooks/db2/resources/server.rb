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
attribute :version, kind_of: String, equal_to: %w(10.5 10.1 9.7), required: true
attribute :das_password, kind_of: String, required: true
attribute :instance_password, kind_of: String, required: true
attribute :fenced_password, kind_of: String, required: true

# Optional attributes
attribute :port, kind_of: Integer, default: 50000, required: false
attribute :fcm_port, kind_of: Integer, default: 60000, required: false
attribute :max_logical_nodes, kind_of: Integer, default: 4, required: false
attribute :instance_type, kind_of: String, equal_to: %w(DSF ESE WSE STANDALONE CLIENT), default: 'ESE', required: false
attribute :instance_username, kind_of: String, default: 'db2inst1', required: false
attribute :fenced_username, kind_of: String, default: 'db2fenc1', required: false
attribute :das_username, kind_of: String, default: 'db2das1', required: false
attribute :download_dir, kind_of: String, default: '/tmp', required: false
attribute :req_packages, kind_of: Array, default: %w(), required: false
