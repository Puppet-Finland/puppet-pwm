# This manifest is only used by Vagrant

host { 'pwm-dirsrv.local':
    ensure => present,
    ip     => '192.168.103.101',
}

include ::tomcat

class { '::pwm':
    build      => true,
    build_user => 'ubuntu',
}
