# encoding: UTF-8
#
# Cookbook Name:: qpid
# Recipe:: passive
#
# =================================================================
# Licensed Materials - Property of IBM
#
# (c) Copyright IBM Corp. 2013, 2014 All Rights Reserved
#
# US Government Users Restricted Rights - Use, duplication or
# disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
# =================================================================

# TODO(wenchma): QPID passive mode is not supported now, only step into active mode.
include_recipe 'qpid::active'
