#!/bin/sh
#
# Prepare 389 Directory Server for use with Pwm
#
PATH=/bin:/sbin:/usr/bin:/usr/sbin

# Enable memberOf plugin and ensure that attribute "uniqueMember" is used to search for users that are part of that group.
ldapmodify -D "cn=Directory Manager" -w vagrant -p 389 -h localhost -x -f /vagrant/vagrant/memberOf.ldif

# Stop the directory server instance.
# This has to be done before importing the database and also to activate the memberOf plugin
systemctl stop dirsrv@vagrant

# Import a minimal database (dc=example,dc=org) modified to work with Pwm
ldif2db -Z vagrant -s 'dc=example,dc=org' -i /vagrant/vagrant/example.org.ldif

# Start the directory server instance
systemctl start dirsrv@vagrant
