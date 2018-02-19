# This manifest is only used by Vagrant

include ::tomcat

class { '::pwm':
    build      => true,
    build_user => 'ubuntu',
}
