# encoding: UTF-8
actions :create

def initialize(*args)
  super
  @action = :create
end

attribute :auth, kind_of: String, default: 'yes', required: false
attribute :port, kind_of: Integer, default: 5672, required: false
attribute :max_connections, kind_of: Integer, default: 2000, required: false
attribute :connection_backlog, kind_of: Integer, default: 1000, required: false
attribute :worker_threads, kind_of: Integer, default: 100, required: false
attribute :max_negotiate_time, kind_of: Integer, default: 60000, required: false
attribute :link_heartbeat_interval, kind_of: Integer, default: 1200, required: false
attribute :log_enable, kind_of: String, default: 'info+', required: false
attribute :log_to_file, kind_of: String, default: '/var/log/qpid/qpidd.log', required: false
attribute :ssl_port, kind_of: Integer, default: 5671, required: false
attribute :cert_name, kind_of: String, default: 'broker', required: false
attribute :cert_db, kind_of: String, default: '/etc/pki/qpid', required: false
attribute :cert_file, kind_of: String, default: '/etc/pki/qpid/cert.password', required: false

attribute :mech, kind_of: String, default: 'QPID', required: false
attribute :username, kind_of: String, default: 'guest', required: false
attribute :password, kind_of: String, default: 'guest', required: false
