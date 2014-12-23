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
# [*manage_config*]
#   Manage Pwm configuration. Valid values 'yes' (default) and 'no'.
# [*dirsrv_type*]
#   Directory server type. Currently only '389ds' is supported. The default 
#   value is 'none', which means that auto-configuration of schemas is omitted.
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
    $manage_config = 'yes',
    $dirsrv_type = 'none'

) inherits pwm::params
{

# Rationale for this is explained in init.pp of the sshd module
if hiera('manage_pwm', 'true') != 'false' {

    include pwm::install

    if $manage_config == 'yes' {
        class { 'pwm::config':
            dirsrv_type => $dirsrv_type,
        }
    }    
}
}
