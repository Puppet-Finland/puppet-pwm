#
# @summary
#   A Puppet module for managing Pwm:
#
#   https://github.com/pwm-project/pwm
#
#   Note that the module expects to find pwm.war at the root of the Puppet 
#   fileserver. This could be avoided if Pwm was packaged for Debian.
#
# @param pwm_download_url
#   The URL from which to download the PWM WAR file
# @param pwm_context
#   Context (path) of Pwm on the Tomcat installation
# @param manage
#   Whether to manage Pwm or not
# @param manage_config
#   Whether to manage Pwm configuration or not
# @param manage_tomcat
#   Whether to manage Tomcat or not
# @param tomcat_webapps_path
#   Webapps directory for Tomcat
# @param tomcat_catalina_host
#   Name of the Pwm host for Tomcat  
# @param tomcat_manager_allow_cidr
#   CIDR blocks to allow traffic from to Tomcat Manager webapp
# @param tomcat_manager_user
#   Username for accessing Tomcat Manager
# @param tomcat_manager_user_password
#   Password for Tomcat Manager user
#
class pwm (
  Stdlib::HttpsUrl     $pwm_download_url,
  String               $pwm_context = 'pwm',
  Boolean              $manage = true,
  Boolean              $manage_config = true,
  Boolean              $manage_tomcat = true,
  Stdlib::Absolutepath $tomcat_webapps_path = '/var/lib/tomcat9/webapps',
  String               $tomcat_catalina_host = 'localhost',
  String               $tomcat_manager_allow_cidr = '127.0.0.1',
  Optional[String]     $tomcat_manager_user = undef,
  Optional[String]     $tomcat_manager_user_password = undef,
) {
  if $manage {
    if $manage_tomcat {
      class { 'pwm::tomcat':
        catalina_host         => $tomcat_catalina_host,
        manager_user          => $tomcat_manager_user,
        manager_user_password => $tomcat_manager_user_password,
        manager_allow_cidr    => $tomcat_manager_allow_cidr,
      }
    }

    class { 'pwm::install':
      context      => $pwm_context,
      download_url => $pwm_download_url,
      webapps_path => $tomcat_webapps_path,
    }
  }
}
