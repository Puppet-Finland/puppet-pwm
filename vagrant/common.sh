#!/bin/sh
export PATH=$PATH:/opt/puppetlabs/bin:/opt/puppetlabs/puppet/bin

wget https://raw.githubusercontent.com/Puppet-Finland/scripts/master/bootstrap/linux/install-puppet.sh -q -O install-puppet.sh
/bin/sh install-puppet.sh -n pwm -p 7

wget https://raw.githubusercontent.com/Puppet-Finland/scripts/master/bootstrap/linux/install-puppet-modules.sh -q -O install-puppet-modules.sh
/bin/sh install-puppet-modules.sh -n pwm
