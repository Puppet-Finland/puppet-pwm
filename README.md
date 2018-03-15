# pwm

A Puppet module for managing Pwm, "Open Source Password Self Service for LDAP 
directories". This version is only tested with Pwm 1.8

# Module usage

The puppet manifest, [pwm.pp](vagrant/pwm.pp) gives an idea on how to use this 
module. For details please refer to documentation in the [main 
class](manifests/init.pp).

# Dependencies

See [metadata.json](metadata.json).

# Testing with Vagrant

This module comes with Vagrant support. Two VMs are included:

* *pwm-dirsrv*: 389 Directory Server instance running on CentOS 7
* *pwm*: Pwm 1.8 instance running on Ubuntu 16.04

Pwm is built from sources in Vagrant, which takes a bit of time when bringing up 
the VM the first time.

To ensure that you can access all the services on these VMs add these to 
/etc/hosts or equivalent:

    192.168.103.100 pwm.local pwm
    192.168.103.101 pwm-dirsrv.local pwm-dirsrv

In particular 389-console depends on these being set - it is not easy to get it 
to play nicely with port forwards.

# Operating system support

This module has been tested on

* Ubuntu 16.04

It should work out of the box or with minor modifications on other Debian/Ubuntu 
derivatives. And earlier version of this module worked on Ubuntu 14.04 but this 
may or may not be the case anymore.

For details see [params.pp](manifests/params.pp).
