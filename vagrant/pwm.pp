notify { 'Provisioning Pwm': }

class { 'pwm':
  tomcat_manager_allow_cidr    => '192.168.59.0/24',
  tomcat_manager_user          => 'admin',
  tomcat_manager_user_password => 'vagrant',
  pwm_download_url             => 'https://github.com/pwm-project/pwm/releases/download/v2_0_1/pwm-2.0.1.war',
}
