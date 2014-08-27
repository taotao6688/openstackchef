#!/bin/bash
# Usage: bash chef_workstation_setup.sh install/remove

arg=$1
chef_server_host='172.16.1.200'
chef_client_pkg='https://opscode-omnibus-packages.s3.amazonaws.com/el/6/x86_64/chef-11.10.4-1.el6.x86_64.rpm'

if [ "x$arg" != 'xinstall' ] && [ "x$arg" != 'xremove' ]; then
    echo 'Usage: bash chef_workstation_setup.sh install/remove'
    exit 1
fi

base_dir=$(cd $(dirname $0) && pwd)
chef_admin_client_key='/root/.chef/admin.pem'
chef_validation_client_key='/root/.chef/chef-validator.pem'

function check_environment() {
    status=0
    if ! ping -c 1 $chef_server_host; then
        status=1
        echo 'Cannot connect to chef server'
        echo ''
    fi

    if ! test -e $chef_admin_client_key; then
        status=1
        echo "Can't find chef admin client key: $chef_admin_client_key"
        echo 'You can find the key on chef-server: /etc/chef-server/admin.pem'
        echo "And put it to: $chef_admin_client_key"
        echo ''
    fi

    if ! test -e $chef_validation_client_key; then
        status=1
        echo "Can't find chef validation client key: $chef_validation_client_key"
        echo 'You can find the key on chef-server: /etc/chef-server/chef-validator.pem'
        echo "And put it to: $chef_validation_client_key"
        echo ''
    fi

    if [ $status -eq 1 ]; then
        exit 1
    fi
}

function chef_workstation_setup() {
    rpm -i "$chef_client_pkg"
    mkdir -p /root/.chef/bootstrap
    /bin/cp -f $base_dir/redhat.erb /root/.chef/bootstrap
    sed -i "s%chef_client_pkg=.*$%chef_client_pkg='$chef_client_pkg'%g" /root/.chef/bootstrap/redhat.erb

    echo '================================================='
    echo 'You MUST input 8+ characters to set your password'
    echo '================================================='
    knife configure -i -y --defaults --admin-client-name=admin --admin-client-key="$chef_admin_client_key" \
        --server-url="https://$chef_server_host" --user=root --validation-client-name=chef-validator \
        --validation-key="$chef_validation_client_key" -c /root/.chef/knife.rb --repository=""

    sleep 1

    if grep -q 'knife\[:distro\]' /root/.chef/knife.rb; then
        sed -i "s/knife\[:distro\].*$/knife\[:distro\] = 'redhat'/g" /root/.chef/knife.rb
    else
        echo "knife[:distro] = 'redhat'" >> /root/.chef/knife.rb
    fi
}

function remove_chef_workstation() {
    yum -y remove chef
    rm -rf /etc/chef /root/.chef
}

if [ $arg = 'install' ]; then
    check_environment
    chef_workstation_setup
elif [ $arg = 'remove' ]; then
    remove_chef_workstation
fi
