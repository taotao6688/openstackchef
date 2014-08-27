# encoding: UTF-8
action :create do
  params = Hash.new
  attributes = %w(auth port max_connections connection_backlog worker_threads max_negotiate_time link_heartbeat_interval log_enable log_to_file ssl_port cert_name cert_db cert_file)
  attributes.each do |attribute|
    if new_resource.respond_to?(attribute)
      params[attribute] = new_resource.send(attribute.to_sym) unless new_resource.send(attribute.to_sym).nil?
    end
  end

  pkgs = node['qpid']['packages']

  # Install qpid packages
  pkgs.each do |pkg|
    package pkg do
      action :upgrade
      retries 5
      retry_delay 10
    end
  end

  # Configure qpid sasl2
  if node['qpid']['sasl']['enable']

    # Install cyrus-sasl-plain package
    package node['qpid']['cyrus-sasl-plain']['package'] do
      action :upgrade
    end

    # Configure /etc/sasl2/qpidd.conf file
    template '/etc/sasl2/qpidd.conf' do
      cookbook 'qpid'
      source 'sasl.qpidd.conf.erb'
      owner 'root'
      group 'root'
      mode '0644'
    end

    # Setup QPID SASL2 database
    file '/var/lib/qpidd/qpidd.sasldb' do
      action :create
      owner node['qpid']['user']
      group node['qpid']['group']
      mode 0640
    end

    # Configure SASL2 admin
    realm = node['qpid']['sasl']['realm']
    cmd = "echo #{node['qpid']['admin']['password']}| saslpasswd2 -p -f #{node['qpid']['sasl']['db']} -u #{realm} #{node['qpid']['admin']['username']}"
    execute cmd do
      Chef::Log.debug "Configuring QPID SASL2 admin: #{cmd}"
      Chef::Log.info "Add admin user to the database: #{node['qpid']['admin']['username']}"
    end

    # Configure SASL2 client
    cmd = "echo #{node['qpid']['client']['password']}| saslpasswd2 -p -f #{node['qpid']['sasl']['db']} -u #{realm} #{node['qpid']['client']['username']}"
    execute cmd do
      Chef::Log.debug "Configuring QPID SASL2 admin: #{cmd}"
      Chef::Log.info "Add admin user to the database: #{node['qpid']['client']['username']}"
    end

    # Setup Qpid ACL file
    template '/var/lib/qpidd/default.acl' do
      cookbook 'qpid'
      source 'default.acl.erb'
      owner node['qpid']['user']
      group node['qpid']['group']
      mode 0600
    end
  end

  # Configure qpid SSL
  if node['qpid']['ssl']['enable']

    # Create a directory to store the certificate database for qpid
    directory node['qpid']['ssl']['cert']['db'] do
      owner node['qpid']['user']
      group node['qpid']['group']
      action :create
      recursive true
    end

    # Create a password file containing the password for SSL database
    template node['qpid']['ssl']['cert']['password_file'] do
      cookbook 'qpid'
      source 'cert.password.erb'
      owner node['qpid']['user']
      group node['qpid']['group']
      mode 0600
    end

    # Create the certifaicate database for qpid
    cert_db = node['qpid']['ssl']['cert']['db']
    cert_file = node['qpid']['ssl']['cert']['password_file']
    cmd = "sudo -u #{node['qpid']['user']} -g #{node['qpid']['group']} certutil -N -d #{cert_db} -f #{cert_file}"
    execute cmd do
      Chef::Log.debug "Creating the certificate database for qpid: #{cmd}"

      only_if { node['qpid']['ssl']['create_self_db'] }
    end

    # Create a certificate and add to database
    nickname = node['qpid']['ssl']['cert']['name']
    cmd = "certutil -S -d #{cert_db} -n #{nickname} -s 'CN=#{nickname}' -t 'CT,,' -x -f #{cert_file} -z /usr/bin/certutil"
    execute cmd do
      Chef::Log.debug "Create a certificate and add to database: #{cmd}"

      only_if { node['qpid']['ssl']['create_self_signed'] }
    end
  end

  # Sleep for service qpidd starting
  execute 'qpidd: sleep' do
    command 'sleep 10s'

    action :nothing
  end

  # Define qpid service resource
  service 'qpidd' do
    service_name node['qpid']['qpid_service']
    supports status: true, restart: true

    action [:enable]

    notifies :run, 'execute[qpidd: sleep]', :immediately
  end

  # Create /var/log/qpid directory
  directory '/var/log/qpid' do
    owner node['qpid']['user']
    group node['qpid']['group']
    mode 0744
    action :create
  end

  # Create qpidd.log file
  file '/var/log/qpid/qpidd.log' do
    action :create
    owner node['qpid']['user']
    group node['qpid']['group']
    mode 0644
  end

  # Create qpidd.conf file
  r = template '/etc/qpid/qpidd.conf' do
    cookbook 'qpid'
    source 'qpidd.conf.erb'
    owner 'root'
    group 'root'
    mode '0644'
    variables(
      'name' => new_resource.name,
      'params' => params
    )
    notifies :restart, 'service[qpidd]', :immediately
  end
  new_resource.updated_by_last_action(r.updated_by_last_action?)

end
