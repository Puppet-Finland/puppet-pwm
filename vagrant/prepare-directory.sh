#!/bin/sh
#
# Prepare 389 Directory Server for use with Pwm
#

SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")

. $SCRIPTPATH/vars

# Do not pull the carpet from beneath 389ds
systemctl stop dirsrv@$INSTANCE

# Cleanup to allow multiple consecutive runs
rm -f $ADMIN_DBPATH/*.db $DBPATH/*.db $PINFILE $PASSFILE

# Import a minimal database (dc=example,dc=org) modified to work with Pwm
ldif2db -Z $INSTANCE -s 'dc=example,dc=org' -i $SOURCE_DIR/example.org.ldif

$SCRIPTPATH/enable-tls-in-slapd.sh

# Start the directory server so that we can ldapmodify/add
systemctl start dirsrv@$INSTANCE

# Enable memberOf plugin
ldapmodify -D "cn=Directory Manager" -w $PASS -x -f $SOURCE_DIR/memberOf.ldif

# Restart to activate the memberOf plugin
systemctl restart dirsrv@$INSTANCE

### Enable TLS for the admin server
$SCRIPTPATH/enable-tls-in-admin-serv.sh

systemctl start dirsrv-admin
