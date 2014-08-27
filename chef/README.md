# Chef Quick Guide

How to use these files under this directory

## Before install

1. Copy this directory to your target machine.

2. Edit chef_server_setup.sh file, set your chef-server IP and chef-server rpm package URL.

3. After installed Chef server, you need to copy `/etc/chef-server/admin.pem` and `/etc/chef-server/chef-validation.pem` to your Chef workstation(`/root/.chef/admin.pem` and `/root/.chef/chef-validation.pem`).

4. Edit chef_workstation_setup.sh file, set your chef-server IP and chef rpm package URL.

## Install Chef server

    bash chef_server_setup.sh install

After install Chef server, your will have a `/etc/chef-server/chef-server.rb` file like this:

    server_name = '172.16.1.200'
    api_fqdn server_name
    nginx['url'] = "https://#{server_name}"
    nginx['server_name'] = server_name
    bookshelf['vip'] = server_name
    chef_solr['commit_interval'] = 1000 # in ms
    erchef['s3_url_ttl'] = 3600

## Install Chef workstation

    bash chef_workstation.sh install

After install Chef workstation, you will have a `/root/.chef/knife.rb` file like this:

    log_level                :info
    log_location             STDOUT
    node_name                'root'
    client_key               '/root/.chef/root.pem'
    validation_client_name   'chef-validator'
    validation_key           '/root/.chef/chef-validator.pem'
    chef_server_url          'https://172.16.1.200'
    syntax_check_cache_path  '/root/.chef/syntax_check_cache'
    knife[:distro] = 'redhat'
    knife[:editor] = 'vim'

And there will be a file `/root/.chef/bootstrap/redhat.erb`.

## Files under this directory

### chef-server.rb

This is chef server configuration file, should put to /etc/chef-server/chef-server.rb

### redhat.erb

This is `knife bootstap` OS distribution template file, usually used to install chef-client on nodes.

## Chef Server and Client packages

URL: https://opscode-omnibus-packages.s3.amazonaws.com/el/6/x86_64/chef-server-11.0.12-1.el6.x86_64.rpm
URL: https://opscode-omnibus-packages.s3.amazonaws.com/el/6/x86_64/chef-11.10.4-1.el6.x86_64.rpm
