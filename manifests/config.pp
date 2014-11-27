#
# == Class: pwm::config
#
# Configure pwm
#
class pwm::config
(
    $dirsrv_type

) inherits pwm::params
{
    case $dirsrv_type {
        '389ds': {
            include pwm::config::dirsrv
        }
        'none': {
            # Do nothing
        }
        default: { fail("Invalid value ${dirsrv_type} for parameter \$dirsrv_type") }
    }
}
