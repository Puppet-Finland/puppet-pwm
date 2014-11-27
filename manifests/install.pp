#
# == Class: pwm::install
#
# Install pwm
#
class pwm::install inherits pwm::params {

    # Use the Tomcat module to install pwm.war
    tomcat::war { 'pwm':
        source => 'puppet:///files/pwm.war'
    }
}
