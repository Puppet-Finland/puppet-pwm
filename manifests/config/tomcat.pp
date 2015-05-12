#
# == Class: pwm::config::tomcat
#
# Pwm-specific Tomcat configuration.
#
class pwm::config::tomcat inherits pwm::params {

    if $::osfamily == 'Debian' {
        include ::pwm::config::tomcat::debian
    }
}
