#
# @summary
#   Set up Tomcat for Pwm
#
class pwm::tomcat
(
  Stdlib::Fqdn $catalina_host,
  String       $manager_allow_cidr,
  String       $manager_user,
  String       $manager_user_password,
){
  package { ['tomcat9', 'tomcat9-admin']:
    ensure => 'present',
  }

  service { 'tomcat9':
    ensure => 'running',
    enable => true,
  }

  $tomcat_users_xml_params = {'manager_user'          => $manager_user,
                              'manager_user_password' => $manager_user_password, }

  file { '/etc/tomcat9/tomcat-users.xml':
    ensure  => 'present',
    owner   => 'root',
    group   => 'tomcat',
    mode    => '0644',
    content => epp('pwm/tomcat-users.xml.epp', $tomcat_users_xml_params),
    notify  => Service['tomcat9'],
  }

  $manager_xml_params = {'allow_cidr' => $manager_allow_cidr, }

  file { "/etc/tomcat9/Catalina/${catalina_host}/manager.xml":
    ensure  => 'present',
    owner   => 'root',
    group   => 'tomcat',
    mode    => '0644',
    content => epp('pwm/manager.xml.epp', $manager_xml_params),
    notify  => Service['tomcat9'],
  }

  file { '/etc/pwm':
    ensure => 'directory',
    owner  => 'tomcat',
    group  => 'tomcat',
    mode   => '0770',
  }

  # Set up PWM's ApplicationPath directory which has Pwm configuration and
  # other files. This is not set by default, which means that Pwm webapp
  # will refuse to launch without this. Also, the systemd unit file bundled
  # with Ubuntu 20.04 sandboxes Tomcat, preventing it from writing to
  # undefined directories even if file system permissions would allow it.
  # Therefore allow tomcat to write to Pwm's ApplicationPath as well.
  systemd::dropin_file { 'pwm.conf':
    unit    => 'tomcat9.service',
    content => epp('pwm/systemd-override-pwm.conf.epp'),
    require => File['/etc/pwm'],
    notify  => Service['tomcat9'],
  }
}
