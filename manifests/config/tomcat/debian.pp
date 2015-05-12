#
# == Class: pwm::config::tomcat::debian
#
# Pwm-specific Tomcat configuration for Debian. Currently limited to setting up 
# Java Security Manager rules.
#
class pwm::config::tomcat::debian inherits pwm::params {

    include ::tomcat::params

    file { 'pwm-51pwm.policy':
        name    => "${::tomcat::params::policy_dir}/51pwm.policy",
        content => template('pwm/51pwm.policy.erb'),
        owner   => root,
        group   => $::tomcat::params::group,
        mode    => '0644',
        require => Class['tomcat'],
    }
}
