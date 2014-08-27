#!/bin/bash
# Usage: bash chef_server_setup.sh install/remove

arg=$1
chef_server_host='172.16.1.200'
chef_server_pkg='https://opscode-omnibus-packages.s3.amazonaws.com/el/6/x86_64/chef-server-11.0.12-1.el6.x86_64.rpm'

if [ "x$arg" != 'xinstall' ] && [ "x$arg" != 'xremove' ]; then
    echo 'Usage: bash chef_server_setup.sh install/remove'
    exit 1
fi

base_dir=$(cd $(dirname $0) && pwd)

function check_environment() {
    if ! ping -c 1 $(hostname); then
        echo -e "127.0.0.1\t$(hostname)" >> /etc/hosts
    fi
}

function chef_server_setup() {
    rpm -i "$chef_server_pkg"
    chef-server-ctl reconfigure
    /bin/cp -f $base_dir/chef-server.rb /etc/chef-server/chef-server.rb
    sed -i "s/server_name = .*$/server_name = '"$chef_server_host"'/g" /etc/chef-server/chef-server.rb
    chef-server-ctl reconfigure
}

function remove_chef_server() {
    chef-server-ctl uninstall
    yum -y remove chef-server
    rm -rf /opt/chef-server /var/opt/chef-server /etc/chef-server
    ps aux | awk '/chef/ && !/'$(basename $0)'/ {print $2}' | xargs kill -9

    uid=$(id -u chef_server)
    if [ "x$uid" != 'x' ]; then
        ps aux | awk '{if($1 == '$uid')print $2;}' | xargs kill -9
        userdel -r chef_server
    fi
}

if [ $arg = 'install' ]; then
    check_environment
    chef_server_setup
elif [ $arg = 'remove' ]; then
    remove_chef_server
fi
