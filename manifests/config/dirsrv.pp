#
# == Class: pwm::config::389ds
#
# Configure 389 Directory Server to work with pwm
#
class pwm::config::dirsrv inherits pwm::params
{
    dirsrv::config::schema { 'pwm-99pwm':
        modulename => 'pwm',
        basename   => '99pwm',
    }
}
