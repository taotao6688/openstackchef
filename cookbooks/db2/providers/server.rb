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

use_inline_resources
action :install do

  if ::File.exists?("/opt/ibm/db2/V#{new_resource.version}")
    puts "\n======================================================="
    puts 'DB2 was already installed'
    puts 'Please uninstall it before installing'
    puts '======================================================='
  else
    params = {}
    attributes = %w(version port fcm_port max_logical_nodes instance_type instance_username instance_password fenced_username fenced_password das_username das_password)
    attributes.each do |attribute|
      if new_resource.respond_to?(attribute)
        params[attribute] = new_resource.send(attribute.to_sym) unless new_resource.send(attribute.to_sym).nil?
      end
    end

    url = new_resource.url
    version = new_resource.version
    download_dir = new_resource.download_dir
    req_packages = new_resource.req_packages

    ## Install DB2 required packages
    req_packages.each do |pkg|
      package pkg do
        action :install
        retries 5
        retry_delay 10
      end
    end

    ## Create DB2 temporary directory
    tmp_dir = "#{download_dir}/ibm/db2"
    directory "#{tmp_dir}/package" do
      owner 'root'
      group 'root'
      mode '0755'
      recursive true
      action :create
    end

    ## Download DB2 package
    ENV['TMP'] = tmp_dir
    pkgname = url.split('/').last.to_s
    remote_file "#{tmp_dir}/#{pkgname}" do
      source url
    end

    ## Extract DB2 package
    execute 'Extract DB2 package' do
      cwd tmp_dir
      command "tar -C #{tmp_dir}/package -xf #{pkgname}"
    end

    ## Create DB2 repsonse file
    rsp_file = "#{tmp_dir}/db2_install.rsp"
    template rsp_file do
      cookbook 'db2'
      source 'db2_install.rsp.erb'
      owner 'root'
      group 'root'
      mode '0644'
      variables(
        'name' => new_resource.name,
        'params' => params
      )
    end

    ## DB2 needs node's hostname resolvable
    execute 'Check db2 node hostname' do
      command 'echo "127.0.0.1 $(hostname)" >> /etc/hosts'
      not_if 'ping -c 1 $(hostname)'
    end

    ## Create uninstall DB2 SHELL script
    template '/root/db2_uninstall.sh' do
      cookbook 'db2'
      source 'db2_uninstall.sh.erb'
      owner 'root'
      group 'root'
      mode '0644'
      variables(
        'name' => new_resource.name,
        'params' => params
      )
    end

    ## Install DB2 using response file
    ## Weird, I can't find any error in DB2 v9.7 install log
    ## but db2setup returns a '1' status when installing v9.7, so I added a returns attribute.
    if version == '9.7'
      returns = [0, 1]
    else
      returns = [0]
    end
    execute 'Install db2' do
      command "cd #{tmp_dir}/package/$(ls #{tmp_dir}/package|head -1) && ./db2setup -l #{tmp_dir}/install.log -r #{rsp_file}"
      returns returns
    end

    ## Create ldconfig file
    ldconf = '/etc/ld.so.conf.d/db2.conf'
    template ldconf do
      cookbook 'db2'
      source 'db2.conf.erb'
      owner 'root'
      group 'root'
      mode '0644'
      variables(
        'name' => new_resource.name,
        'params' => params
      )
      # notifies :run, 'execute[ldconfig]', :immediately
    end

    execute 'ldconfig' do
      command 'ldconfig'
    end

    ## Create db2.service in init.d dir
    template '/etc/rc.d/init.d/db2.service' do
      cookbook 'db2'
      source 'db2.service.erb'
      owner 'root'
      group 'root'
      mode '0755'
      variables(
        'name' => new_resource.name,
        'params' => params
      )
      # notifies :enable, 'service[db2.service]', :delayed
    end

    ## Add autostart after reboot
    service 'db2.service' do
      action :enable
    end

    ## Remove tmp dir
    directory tmp_dir do
      recursive true
      action :delete
    end

  end

end
