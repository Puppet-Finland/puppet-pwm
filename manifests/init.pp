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
    Boolean $manage_config = true

) inherits pwm::params
{

if $manage {

    include ::pwm::install

    if $manage_config {
        include ::pwm::config
    }
}
}
