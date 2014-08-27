#
# Cookbook Name: pacemaker
# Provider:: config
#
#

action :create do
    params = Hash.new()
    platform_options = node["pacemaker"]["platform"]
    attributes = [
      'cluster_nodes', 'cluster_name'
    ]
    attributes.each do |attribute|
        if new_resource.respond_to?(attribute)
            params[attribute] = new_resource.send(attribute.to_sym) unless new_resource.send(attribute.to_sym).nil?
        end
    end
    
    template "cluster" do
      path "/etc/cluster/cluster.conf"
      source "cluster.conf.erb"
      owner "root"
      group "root"
      mode "0664"
      variables(
          "params" => params
      )
    end
    
end
