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

## db2 server
default['db2']['port'] = 50000
default['db2']['version'] = '10.5'
default['db2']['url'] = 'http://127.0.0.1/DB2_Svr_10.5.0.1_Linux_x86-64.tar.gz'
default['db2']['instance_type'] = 'ESE'
default['db2']['instance_username'] = 'db2inst1'
default['db2']['instance_password'] = 'passw0rd'
default['db2']['database_data_dir'] = '/home/db2inst1'
default['db2']['das_username'] = 'db2das1'
default['db2']['das_password'] = 'passw0rd'
default['db2']['fenced_username'] = 'db2fenc1'
default['db2']['fenced_password'] = 'passw0rd'
default['db2']['fcm_port'] = 60000
default['db2']['max_logical_nodes'] = 4
default['db2']['download_dir'] = '/tmp'
default['db2']['req_packages'] = %w(libaio dapl sg3_utils libibcm ibsim ibutils libcxgb3 libipathverbs libibmad libibumad libipathverbs libmthca libnes rdma)

## db2 odbc driver
default['db2']['odbc_url'] = 'http://127.0.0.1/v10.5fp3_linuxx64_odbc_cli.tar.gz'

## db2 database
default['db2']['db_name'] = 'dbname'
default['db2']['db_pagesize'] = 16384
default['db2']['db_territory'] = 'CN'

## db2 user
default['db2']['db_user'] = 'dbuser'
default['db2']['db_pass'] = 'passw0rd'
default['db2']['db_privileges'] = 'dbadm'

## DB2 HA attributes
default['db2']['primary_host'] = '172.16.1.220'
default['db2']['standby_host'] = '172.16.1.219'
default['db2']['primary_port'] = 10000
default['db2']['standby_port'] = 10000
