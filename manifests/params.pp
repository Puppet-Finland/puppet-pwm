#
# == Class: pwm::params
#
# Defines some variables based on the operating system
#
class pwm::params {

    case $::osfamily {
        'Debian': {
            # 389 DS main configuration directory
            $dirsrv_config_dir = '/etc/dirsrv'
        }
        default: {
            fail("Unsupported operating system: ${::osfamily}/${::operatingsystem}")
        }
    }
}
