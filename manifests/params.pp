#
# == Class: pwm::params
#
# Defines some variables based on the operating system
#
class pwm::params {

    case $::osfamily {
        'Debian': {
            $build_deps = ['maven']
            $application_path = '/etc/pwm'
        }
        default: {
            fail("Unsupported operating system: ${::osfamily}/${::operatingsystem}")
        }
    }
}
