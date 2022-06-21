notify { 'Provisioning Pwm': }

class { 'pwm':
  tomcat_admin_user          => 'admin',
  tomcat_admin_user_password => 'vagrant',
}
