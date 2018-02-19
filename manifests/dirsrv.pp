#
# == Class: pwm::dirsrv
#
# Install Pwm schemas to 389 Directory Server
#
class pwm::dirsrv inherits pwm::params {

    include ::dirsrv::params

    dirsrv::config::schema { 'pwm-99pwm':
        modulename => 'pwm',
        basename   => '99pwm',
    }
}
