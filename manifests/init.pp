#
# == Class: pwm
#
# A Puppet module for managing Pwm:
#
# https://github.com/pwm-project/pwm
#
# Note that the module expects to find pwm.war at the root of the Puppet 
# fileserver. This could be avoided if Pwm was packaged for Debian.
#
# == Parameters
#
# [*manage*]
#   Manage Pwm with Puppet. Valid values are true (default) and false.
# [*manage_config*]
#   Manage Pwm configuration with Puppet. Valid values are true (default) and 
#   false.
# [*build*]
#   Build Pwm from sources. Primarily intended for use with Vagrant. Valid 
#   values are true and false (default).
# [*build_user*]
#   User to build Pwm as. Primarily intended for use with Vagrant. No default 
#   value. Note that building as 'root' does not seem to work and is hence
#   prevented.
# [*war_source*]
#   Location of the pwm war file. Passed on to the ::tomcat::war resource when 
#   $build is false. Defaults to 'puppet:///files/pwm.war' under the assumption 
#   that in production enviroments a customized pwm.war is built outside of this 
#   module and distributed via the Puppet fileserver. This parameter has no 
#   effect if $build is true.
# [*config_source*]
#   Location of a customized PwmConfiguration.xml file. Passed on to the Puppet 
#   File resource "source" parameter. Defaults to 
#   "puppet:///files/pwm-PwmConfiguration-${::fqdn}.xml" under the assumption 
#   that a customized configuration file is distributed via Puppet fileserver.
#
# == Authors
#   
# Samuli Seppänen <samuli@openvpn.net>
#   
# == License
# 
# BSD-license. See file LICENSE for details.
#
class pwm
(
  Boolean $manage = true,
  Boolean $manage_config = true,
  Boolean $manage_apache = true,
  Boolean $manage_openjdk = true,
  Boolean $manage_tomcat = true,
  Optional[String] $tomcat_admin_user = undef,
  Optional[String] $tomcat_admin_user_password = undef,
  #            $build = false,
  #            $build_user = undef,
  #            $war_source = 'puppet:///files/pwm.war',
  #            $config_source = "puppet:///files/pwm-PwmConfiguration-${::fqdn}.xml"
) inherits pwm::params
{

  if $manage {

    if $manage_apache {
      class { 'pwm::apache': }
    }

    if $manage_openjdk {
      class { 'pwm::openjdk': }
    }

    if $manage_tomcat {
      class { 'pwm::tomcat':
        admin_user          => $tomcat_admin_user,
        admin_user_password => $tomcat_admin_user_password,
      }
    }
    
    #class { '::pwm::install':
    #  build      => $build,
    #  build_user => $build_user,
    #  war_source => $war_source,
    #}
   
    #if $manage_config {
    #  class { '::pwm::config':
    #      config_source => $config_source,
    #  }
    #}
  }
}
