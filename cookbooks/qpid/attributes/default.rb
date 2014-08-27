# encoding: UTF-8
# qpid broker option
default['qpid']['broker']['port'] = 5672
default['qpid']['broker']['auth'] = 'no'
default['qpid']['broker']['max-connections'] = 2000
default['qpid']['broker']['connection-backlog'] = 1000
default['qpid']['broker']['worker-threads'] = 100
default['qpid']['broker']['max-negotiate-time'] = 60000
default['qpid']['broker']['link-heartbeat-interval'] = 1200
default['qpid']['broker']['log-enable'] = 'info+'
default['qpid']['broker']['log-to-file'] = '/var/log/qpid/qpidd.log'

# default authentication option
default['qpid']['sasl']['enable'] = false
default['qpid']['sasl']['realm'] = 'QPID'
default['qpid']['sasl']['db'] = '/var/lib/qpidd/qpidd.sasldb'
default['qpid']['acl']['file'] = '/var/lib/qpidd/default.acl'
default['qpid']['client']['username'] = 'qpid'
default['qpid']['client']['password'] = 'qpid'
default['qpid']['admin']['username'] = 'admin'
default['qpid']['admin']['password'] = 'admin'

# qpid SSL option
default['qpid']['ssl']['enable'] = false
default['qpid']['ssl']['create_self_db'] = true
default['qpid']['ssl']['create_self_signed'] = true
default['qpid']['ssl']['cert']['db'] = '/etc/pki/qpid'
default['qpid']['ssl']['cert']['password'] = 'password'
default['qpid']['ssl']['cert']['password_file'] = '/etc/pki/qpid/cert.password'
default['qpid']['ssl']['cert']['name'] = 'broker'
default['qpid']['ssl']['port'] = 5671

default['qpid']['user'] = 'qpidd'
default['qpid']['group'] = 'qpidd'

# qpid ha option
default['qpid']['ha']['vip'] = '172.16.1.20'
default['qpid']['ha']['vip_if'] = 'eth0'
default['qpid']['ha']['brokers_url'] = ['172.16.1.25', '172.16.1.26']

default['qpid']['ha']['replicate'] = 'all'
default['qpid']['ha']['backup_timeout'] = 5
default['qpid']['ha']['username'] = 'guest'
default['qpid']['ha']['password'] = 'guest'
default['qpid']['ha']['mechanism'] = 'MECH'

# If platform_family is fedora, platform is fedora. For rhel, platforms includes redhat, centos and ibm_powerkvm.
case platform_family
when 'fedora', 'rhel'
  default['qpid']['qpid_service'] = 'qpidd'
  default['qpid']['packages'] = %w(qpid-cpp-server qpid-tools python-qpid-qmf)
  default['qpid']['cyrus-sasl-plain']['package'] = 'cyrus-sasl-plain'
  default['qpid']['ha_packages'] = %w(qpid-cpp-server-ha python-qpid-qmf)
else
  exit("This cookbook doesn't support your platform(#{platform_family})")
end
