
actions :create, :add_operation

default_action :create


def initialize(*args)
  super
  @action = :create
end

attribute :pm_resource_name, :kind_of => String, :required => true
attribute :agent_name, :kind_of => String, :required => true
attribute :op_param, :kind_of => Hash, :required => true
attribute :params, :kind_of => Hash, :required => true
attribute :type, :kind_of => String, :required => true

