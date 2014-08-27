#!/bin/bash
#
# create databags
# be careful when you run this script
#

key_path=/root/.chef/databag-secret-key

base_dir=$(cd $(dirname $0) && pwd)
bags=(db_passwords user_passwords service_passwords)

user_passwords=(guest admin nova monitoring mysqlroot db2_das db2_fenced db2_instance)
db_passwords=(keystone cinder glance nova neutron horizon ceilometer heat)
service_passwords=(netapp netapp-filer openstack-block-storage nova openstack-compute rbd_block_storage openstack-network openstack-image swift_store_user rabbit_cookie)

## Generate databag key and add to knife.rb file
function configure_databag() {
  openssl rand -base64 512 > $key_path
  if grep -q 'knife\[:secret_file\]' /root/.chef/knife.rb; then
    sed -i "s#knife\[:secret_file\].*\$#knife\[:secret_file\] = '"$key_path"'#g" /root/.chef/knife.rb
  else
    echo "s#knife\[:secret_file\].*\$#knife\[:secret_file\] = '"$key_path"'#g" >> /root/.chef/knife.rb
  fi
}

## Delete old databags
function delete_databags() {
  knife data bag list | xargs -i knife data bag delete -y {}
}

## generate random password
function random_password() {
  password=$(dd if=/dev/urandom count=1 2>/dev/null | md5sum)
  echo ${password:0:7}
}

## Create databags[items]
function create_databag_file() {
  ## create user_passwords databag
  databag_dir=$base_dir/user_passwords
  mkdir -p $databag_dir
  knife data bag create user_passwords
  for item in ${user_passwords[@]}; do
    password=$(random_password)
    echo -e "{\n\t\"id\": \"$item\",\n\t\"$item\": \"$password\"\n}" > $databag_dir/$item.json
  done
  knife data bag from file user_passwords $databag_dir

  ## create db_passwords databag
  databag_dir=$base_dir/db_passwords
  mkdir -p $databag_dir
  knife data bag create db_passwords
  for item in ${db_passwords[@]}; do
    password=$(random_password)
    echo -e "{\n\t\"id\": \"$item\",\n\t\"$item\": \"$password\"\n}" > $databag_dir/$item.json
  done
  knife data bag from file db_passwords $databag_dir

  ## create service_passwords databag
  databag_dir=$base_dir/service_passwords
  mkdir -p $databag_dir
  knife data bag create service_passwords
  for item in ${service_passwords[@]}; do
    password=$(random_password)
    echo -e "{\n\t\"id\": \"$item\",\n\t\"$item\": \"$password\"\n}" > $databag_dir/$item.json
  done
  knife data bag from file service_passwords $databag_dir

}

function main() {
  configure_databag
  delete_databags
  create_databag_file
}

main
