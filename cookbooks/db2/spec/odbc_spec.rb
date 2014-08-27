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

describe 'db2::odbc' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it 'installs odbc driver' do
    expect(chef_run).to install_db2_odbc('install odbc driver')
  end
end
