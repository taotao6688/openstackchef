log_level                :info
log_location             STDOUT
node_name                'root'
client_key               '/root/.chef/root.pem'
validation_client_name   'chef-validator'
validation_key           '/etc/chef-server/chef-validator.pem'
chef_server_url          'https://172.16.1.200'
syntax_check_cache_path  '/root/.chef/syntax_check_cache'
secret_file              '/etc/chef-server/databag-key'
# encrypted_data_bag_secret '/etc/chef-server/databag-key'

# distro, the file in ~/.chef/bootstrap/redhat.erb
knife[:distro] = 'redhat'
knife[:editor] = 'vim'
knife[:secret_file] = '/etc/chef-server/databag-key'
