#
# == Class: pwm
#
# A Puppet module for managing Pwm:
#
# <https://code.google.com/p/pwm>
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
# [*dirsrv_type*]
#   Directory server type. Currently only '389ds' is supported. The default 
#   value is undef, which means that auto-configuration of schemas is omitted.
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
            $dirsrv_type = undef

) inherits pwm::params
{

if $manage {

    include ::pwm::install

    if $manage_config {
        class { '::pwm::config':
            dirsrv_type => $dirsrv_type,
        }
    }
}
}
