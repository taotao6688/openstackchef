#!/bin/bash
#
# This script is used to fetch git submodule cookbooks
# and apply our patch for these cookbooks
#

base_dir=$(dirname $(cd $(dirname $0) && pwd))

## reset cookbooks to initial status
function reset_cookbooks() {
    cookbooks=$(ls $base_dir/cookbooks)
    for cookbook in $cookbooks
    do
        cookbook_dir=$base_dir/cookbooks/$cookbook
        if test -d $cookbook_dir/.git; then
            cd $cookbook_dir
            git status -s | awk '{print $2}' | xargs rm -rf
            git checkout -- .
        fi
    done
}

## resest openstack-devops to initial status
function reset_openstack_devops() {
    cd $base_dir
    git status -s | awk '{print $2}' | xargs rm -rf
    git checkout -- .
}

## update openstack-devops
function update_submodules() {
    cd $base_dir
    current_branch=$(git rev-parse --abbrev-ref HEAD)
    git pull origin $current_branch
    git submodule init && git submodule update
}

## apply our patches for cookbooks
function apply_patch() {
    /bin/cp -rf $base_dir/files/cookbooks/* $base_dir/cookbooks 
}

reset_cookbooks
reset_openstack_devops
update_submodules
apply_patch
