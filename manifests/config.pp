#
# @summary configure Pwm
#
# Configure pwm
#
class pwm::config
(
    String $config_source

) inherits pwm::params
{

    include ::tomcat::params

    File {
        ensure  => 'directory',
        owner   => $::tomcat::params::user,
        group   => $::tomcat::params::group,
        mode    => '0755',
    }

    # Create a configuration directory for Pwm (older versions modified the 
    # files under the webapp directory directly)
    file { 'pwm-application_path':
        name => $::pwm::params::application_path,
    }

    file { 'pwm-logs':
        name    => "${::pwm::params::application_path}/logs",
        require => File['pwm-application_path'],
    }

    file { 'pwm-temp':
        name    => "${::pwm::params::application_path}/temp",
        require => File['pwm-application_path'],
    }

    # Allow pwm to write to the webapp directories it needs
    file { 'pwm-WEB-INF':
        name    => "${::tomcat::params::autodeploy_dir}/pwm/WEB-INF",
        require => Class['pwm::install'],
    }

    file { 'pwm-LocalDB':
        name    => "${::tomcat::params::autodeploy_dir}/pwm/WEB-INF/LocalDB",
        require => Class['pwm::install'],
    }

    # Set Pwm application path
    augeas { 'pwm applicationPath':
        incl    => "${::tomcat::params::autodeploy_dir}/pwm/WEB-INF/web.xml",
        lens    => 'Xml.lns',
        changes => "set web-app/context-param/param-value/#text ${::pwm::params::application_path}",
        require => Class['::pwm::install'],
        notify  => Class['::tomcat::service'],
    }

    # Pwm webapp configuration
    file { 'pwm-PwmConfiguration.xml':
        ensure => present,
        name   => "${::pwm::params::application_path}/PwmConfiguration.xml",
        source => $config_source,
        mode   => '0644',
    }

    # Tomcat configuration
    include ::pwm::config::tomcat
}
