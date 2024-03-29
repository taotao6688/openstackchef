# encoding: UTF-8
#
# Cookbook Name:: openstack-common
# recipe:: openrc
#
# Copyright 2014 IBM Corp.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

class ::Chef::Recipe # rubocop:disable Documentation
  include ::Openstack
end

identity_service_role = node['openstack']['identity_service_chef_role']
keystone = search_for(identity_service_role).first

return if keystone.nil?

ksadmin_tenant_name = keystone['openstack']['identity']['admin_tenant_name']
ksadmin_user = keystone['openstack']['identity']['admin_user']

ksadmin_pass = get_password 'user', ksadmin_user
identity_endpoint = endpoint 'identity-api'

template '/root/openrc' do
  source 'openrc.erb'
  # Must be root!
  owner  'root'
  group  'root'
  mode   00600
  variables(
    user: ksadmin_user,
    tenant: ksadmin_tenant_name,
    password: ksadmin_pass,
    identity_endpoint: identity_endpoint.to_s
  )
end
