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
}
