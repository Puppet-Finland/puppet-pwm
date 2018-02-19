#
# == Class: pwm::params
#
# Defines some variables based on the operating system
#
class pwm::params {

    case $::osfamily {
        'Debian': {
            # Nothing here
        }
        default: {
            fail("Unsupported operating system: ${::osfamily}/${::operatingsystem}")
        }
    }
}
