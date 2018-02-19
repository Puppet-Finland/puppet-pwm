#
# == Class: pwm::params
#
# Defines some variables based on the operating system
#
class pwm::params {

    include ::os::params

    case $::osfamily {
        'Debian': {
            $build_deps = ['maven']
        }
        default: {
            fail("Unsupported operating system: ${::osfamily}/${::operatingsystem}")
        }
    }
}
