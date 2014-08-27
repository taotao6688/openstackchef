
actions :create

default_action :create


def initialize(*args)
  super
  @action = :create
end

attribute :cluster_name, :kind_of => String, :required => true
attribute :cluster_nodes, :kind_of => Array, :required => true
