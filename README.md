# pwm

A Puppet module for managing Pwm, "Open Source Password Self Service for LDAP 
directories". This version is tested using latest Pwm as of July 2022.

# Module usage

The puppet manifest, [pwm.pp](vagrant/pwm.pp) gives an idea on how to use this 
module:

```
class { 'pwm':
  tomcat_manager_allow_cidr    => '192.168.59.0/24',
  tomcat_manager_user          => 'admin',
  tomcat_manager_user_password => 'vagrant',
  pwm_download_url             => 'https://github.com/pwm-project/pwm/releases/download/v2_0_1/pwm-2.0.1.war',
}
```

For details please refer to documentation in the [main class](manifests/init.pp).

# Testing with Vagrant

This module comes with Vagrant support. You can test Pwm against a 389
Directory Server by launching "pwm" in this repo, and "dirsrv" in
[puppet-dirsrv](https://github.com/Puppet-Finland/puppet-dirsrv) repo. 

If you're using LDAPS (636/tcp) then ensure that you have entries in /etc/hosts
that simulate a production DNS setup.
