#
# @summary
#   Set up Tomcat for Pwm
#
class pwm::tomcat
(
  String $admin_user,
  String $admin_user_password
){
  package { ['tomcat9', 'tomcat9-admin']:
    ensure => 'present',
  }

  service { 'tomcat9':
    ensure => 'running',
    enable => true,
  }

  $tomcat_users_xml_params = {'admin_user'          => $admin_user,
                              'admin_user_password' => $admin_user_password, }

  file { '/etc/tomcat9/tomcat-users.xml':
    ensure  => 'present',
    owner   => 'root',
    group   => 'tomcat',
    mode    => '0750',
    content => epp('pwm/tomcat-users.xml.epp', $tomcat_users_xml_params),
    notify  => Service['tomcat9'],
  }
}