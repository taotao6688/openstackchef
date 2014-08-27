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

describe 'db2::database' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it 'creates database' do
    expect(chef_run).to create_db2_database('create database')
  end
end
