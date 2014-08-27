# Description

Install and configure qpid in stand alone mode and active/passive mode

# Requirements

Chef 11 with Ruby 1.9.x required.

Note. Remove the gnote package if existed.

# Platforms

* RHEL-6.x

# Usage

This is a stand alone cookbook, but you can also use this cookbook with `openstack-ops-messaging` cookbooks.

MRV Notes: I removed ops messaging and used this instead:

Environment attribute needed:

        :openstack => {
          :mq => {
            :service_type => 'qpid'
          },

Recipe added to run list:

         "recipe[qpid::single]",


Added this to Berkshelf

         cookbook 'qpid', path: 'C:/Users/IBM_ADMIN/Documents/GitHub/qpid'


# Resources/Providers

* `qpid_setup` Will setup a QPID single node environment
* `qpid_ha_setup` Will setup a QPID HA environment

# Templates

* `qpidd.conf.erb` For QPID single node environment(QPID version > = 2.4)
* `qpidd-ha.conf.erb` For QPID HA environment
* `sasl.qpidd.conf.erb` For QPID SASL2 configuration
* `default.acl.erb` For QPID ACL configuration

# Recipes

## default

- nothing

## single

- Install and configure QPID in single node mode

## active

- Install and configure QPID HA in active mode

## passive

- Install and configure QPID HA in passive mode

# Attributes

* `qpid['broker']['log-to-file']` - Default QPID log file contains log output, leave this default.
* `qpid['user']` - QPID deamon user, leave the default.
* `qpid['group']` - QPID deamon group, leave the default.

Attributes for the QPID SASL are in the ['qpid']['sasl'] namespace.

* `qpid['sasl']['enable']` - Enables/disables SASL authentication for QPID broker, the default is false, disabled.
* `qpid['sasl']['realm']` - SASL authentication domain realm, the default is QPID, but a different can be specified.
* `qpid['sasl']['db']` - Default SALS database contains broker user names and passwords to auth.
* `qpid['acl']['file']` - Default auth policy file, access control list, leave this default.
* `qpid['client']['username']` - Default username for QPID client auth connection, contained in SASL database.
* `qpid['client']['password']` - Default password for QPID client auth connection, contained in SASL database.

Attributes for the QPID SSL are in the ['qpid']['ssl'] namespace.

* `qpid['ssl']['enable']` - Enables/disables SSL for QPID broker, the default is false, disabled.
* `qpid['ssl']['create_self_db']` - Enables/disables user creating new certificate database, the default is true, enabled. If false, user needs to specify the db path.
* `qpid['ssl']['create_self_signed']` - Enables/disables user creating new certificate, the default is true, enabled. If false, user needs to specify the password file.
* `qpid['ssl']['cert']['db']` - Path to directory containing certificate database.
* `qpid['ssl']['cert']['password']` - Password for accessing certificate database.
* `qpid['ssl']['cert']['password_file']` - Plain-text file containing password to use for accessing certificate database.
* `qpid['ssl']['cert']['name']` - Name of the certificate to use.
* `qpid['ssl']['port']` - Port on which to listen for SSL connections.
