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

  if ::File.exists?('/opt/ibm/db2/odbc_cli')
    puts "\n======================================================="
    puts 'DB2 odbc driver was already installed'
    puts 'Please uninstall it before installing'
    puts '======================================================='
  else

    install_dir = '/opt/ibm/db2'
    url = new_resource.url
    download_dir = new_resource.download_dir

    ## Create ODBC temporary directory
    tmp_dir = "#{download_dir}/ibm/db2"
    directory tmp_dir do
      owner 'root'
      group 'root'
      mode '0755'
      recursive true
      action :create
    end

    ## Download ODBC package
    pkgname = url.split('/').last.to_s
    ENV['TMP'] = tmp_dir
    remote_file "#{tmp_dir}/#{pkgname}" do
      source url
    end

    ## Create ODBC install directory
    directory install_dir do
      owner 'root'
      group 'root'
      mode '0755'
      recursive true
      action :create
    end

    ## Extract ODBC package
    execute 'Extract ODBC package' do
      cwd tmp_dir
      command "tar -C #{install_dir} -xf #{pkgname}"
    end

    ## Create ldconfig file
    ldconf = '/etc/ld.so.conf.d/db2-odbc.conf'
    template ldconf do
      cookbook 'db2'
      source 'db2-odbc.conf.erb'
      owner 'root'
      group 'root'
      mode '0644'
      variables(
        'name' => new_resource.name,
        'install_dir' => install_dir
      )
      # notifies :run, 'execute[ldconfig]', :immediately
    end

    execute 'ldconfig' do
      command 'ldconfig'
    end

    ## Remove tmp dir
    directory tmp_dir do
      recursive true
      action :delete
    end

  end

end
