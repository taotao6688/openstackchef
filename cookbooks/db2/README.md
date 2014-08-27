# IBM DB2 cookbook

## Purpose

Install/Configure DB2

## Requirements

### Chef Server

Chef Server >= 11.0

### Platform

RHEL/CentOS >= 6.3

### Cookbooks

* keepalived

## Chef Attributes

For Information on specific attributes please see the attributes/ directory.

## Server Preparation

Please place your DB2 package to a proper place.

DB2 download page: <https://www-304.ibm.com/support/docview.wss?uid=swg27007053>

## Configure Environment Overrides

You are required to provide some attributes for your DB2 deployment. These can be overridden at the environment level or at the node level, but the environmental level is strongly recommended.

The `db2.json` file under environment directory is an example of the attributes that can be used to deploy an environment.

## Installation Overview

The instructions below provide a general overview of steps you will perform to install a DB2 environment. It demonstrates a typical DB2 installation.

### Upload DB2 cookbook

    knife cookbook upload db2 -o db2_parent_directory

### Upload DB2 roles

    knife role from file db2/roles/*.rb

### Upload DB2 environment

    knife environment from file db2/environments/db2.json

### Install DB2 Driver(ODBC)

    knife bootstrap NODE_FQDN -u root -p password -E ENVIRONMENT -r 'role[db2-odbc]'

### Install DB2 Server

    knife bootstrap NODE_FQDN -u root -p password -E ENVIRONMENT -r 'role[db2-install]'

### Install DB2 and create database

    knife bootstrap NODE_FQDN -u root -p password -E ENVIRONMENT -r 'role[db2-install],role[db2-database]'

### Install DB2, create database and create user

    knife bootstrap NODE_FQDN -u root -p password -E ENVIRONMENT -r 'role[db2-install],role[db2-database],role[db2-user]'

### DB2 HA

    knife bootstrap PRIMARY_NODE_FQDN -u root -p password -E ENVIRONMENT -r 'role[db2-primary]'
    knife bootstrap STANDBY_NODE_FQDN -u root -p password -E ENVIRONMENT -r 'role[db2-standby]'

## Use DB2 Native Client

    su - db2inst1
    db2
    list database directory
    connect to dbname [user dbuser using password]
    list tables

More: <https://github.rtp.raleigh.ibm.com/openstackchef/oss-openstack/wikis/db2>

## DB2 with GPFS

If you use GPFS, you can set the `node['db2']['database_data_dir']` to your GPFS mount point(shoulbe writeable by DB2 instance user), like `/gpfs/db2`.

## DB2 database schema

One DB2 database user has one default schema, and the username is the schema name, so I ignored schema concept in this cookbook.

## DB2 with OpenStack

DB2 driver(odbc) should be installed on every OpenStack service(keystone/nova...) node if DB2 servier is install on an isolate node.

## WTF

DB2 database name and username MUST be no more than 8 characters.

## Authors

|                      |                                                    |
|:---------------------|:---------------------------------------------------|
| **Author**           |  Chen Zhiwei (<zhiwchen@cn.ibm.com>)               |
