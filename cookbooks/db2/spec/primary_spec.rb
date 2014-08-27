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

require_relative 'spec_helper'

describe 'db2::primary' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it 'sets up db2 primary node' do
    expect(chef_run).to setup_db2_primary('setup DB2 primary')
  end
end
