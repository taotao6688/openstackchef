actions :create

default_action :create


def initialize(*args)
  super
  @action = :create
end

attribute :resource, :kind_of => String, :required => true
attribute :ip, :kind_of => String, :required => true
attribute :cidr_netmask, :kind_of => String, :required => true
attribute :op_param, :kind_of => Hash, :required => true

