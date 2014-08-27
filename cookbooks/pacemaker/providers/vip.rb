action :create do
    params = Hash.new()
    attributes = ['resource', 'ip', 'cidr_netmask', 'op_param']
    attributes.each do |attribute|
        if new_resource.respond_to?(attribute)
            params[attribute] = new_resource.send(attribute.to_sym) unless new_resource.send(attribute.to_sym).nil?
        end
    end
    ops = new_resource.op_param
    op_command = ''
    ops.each do |op, value|
        op_command = op_command + ' op ' + op + ' ' + value
    end
    pm_ip = new_resource.ip
    pm_netmask = new_resource.cidr_netmask
    pm_resource_name = new_resource.resource
    execute "create resource #{pm_resource_name}" do
        command "pcs resource create #{pm_resource_name}_VIP ocf:heartbeat:IPaddr2 ip=#{pm_ip} cidr_netmask=#{pm_netmask} #{op_command}"
        not_if "pcs resource | awk '/VIP/ {system(\"pcs resource show \"$1)}'|grep #{pm_ip}"
    end
end
