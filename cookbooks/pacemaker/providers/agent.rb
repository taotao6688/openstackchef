action :create do
    params = Hash.new()
    attributes = ['agent_name', 'op_param', 'pm_resource_name', 'params', 'type']
    attributes.each do |attribute|
        if new_resource.respond_to?(attribute)
            params[attribute] = new_resource.send(attribute.to_sym) unless new_resource.send(attribute.to_sym).nil?
        end
    end
    pm_resource_name = new_resource.pm_resource_name
    agent_name = new_resource.agent_name
    ops = new_resource.op_param
    type = new_resource.type
    op_command = ''
    ops.each do |op, value|
        op_command = op_command + ' op ' + op + ' ' + value
    end
    if type == 'master'
        op_command = op_command + ' --master'
    end
    resource_params = new_resource.params
    params_command = ''
    resource_params.each do |resource_param, value|
        params_command = params_command + resource_param + '="' + value + '" '
    end
    if type == 'active/passive'
        execute "create resource #{pm_resource_name}" do
            command "pcs resource create #{pm_resource_name} #{agent_name} #{params_command} #{op_command}"
            not_if "pcs resource | grep '#{pm_resource_name}'"
        end
    else
        execute "delete resource #{pm_resource_name}" do
            command "pcs resource delete #{pm_resource_name}"
            only_if "pcs resource | grep '#{pm_resource_name}-#{type}' | grep -vi mysql"
        end
        execute "create resource #{pm_resource_name}" do
            command "pcs resource create #{pm_resource_name} #{agent_name} #{params_command} #{op_command}"
            not_if "pcs resource | grep '#{pm_resource_name}-#{type}'"
        end
    end
    execute "resource #{pm_resource_name} sleep" do
        command "sleep 5s"
    end
    if type == 'clone'
        execute "clone resource #{pm_resource_name}" do
            command "pcs resource clone #{pm_resource_name}"
            not_if "pcs resource | grep '#{pm_resource_name}-clone'"
        end
    end
    if type != 'active/passive'
        execute "clean resource #{pm_resource_name}" do
            command "crm_resource --resource #{pm_resource_name}-#{type} --cleanup"
        end
    end
    execute "clean resource #{pm_resource_name}" do
       command "crm_resource --resource #{pm_resource_name} --cleanup"
       retries 5
       retry_delay 30
    end
end

action :add_operation do
    params = Hash.new()
    attributes = ['op_param', 'pm_resource_name']
    attributes.each do |attribute|
        if new_resource.respond_to?(attribute)
            params[attribute] = new_resource.send(attribute.to_sym) unless new_resource.send(attribute.to_sym).nil?
        end
    end
    pm_resource_name = new_resource.pm_resource_name
    ops = new_resource.op_param
    op_command = ''
    ops.each do |op, value|
        op_command = op_command + ' ' + op + ' ' + value
    end
    execute "add operation for resource  #{pm_resource_name}" do
        command "pcs resource op add #{pm_resource_name} #{op_command}"
    end
end
