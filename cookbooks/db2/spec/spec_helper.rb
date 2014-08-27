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

require 'chefspec'
require 'chefspec/berkshelf'
require_relative 'support/matcher'

## This will remove any coverage warnings from dependent cookbooks
ChefSpec::Coverage.filters << '*/db2'
at_exit { ChefSpec::Coverage.report! }
