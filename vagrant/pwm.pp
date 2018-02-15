# This manifest is only used by Vagrant

include ::tomcat

ensure_resource('package','maven', { 'ensure' => 'present' })

class { '::pwm': }
