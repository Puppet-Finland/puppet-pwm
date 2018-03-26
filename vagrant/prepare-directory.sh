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
systemctl stop dirsrv-admin

# Reuse directory server cert/key for the admin server
pk12util -o $PK12FILE -n server-cert -W $PASS -K $PASS -d $DBPATH
pk12util -i $PK12FILE -d /etc/dirsrv/admin-serv/ -W $PASS -K $PASS

chown dirsrv:dirsrv $ADMIN_DBPATH/*.db
chmod 600 $ADMIN_DBPATH/*.db

rm -f $PK12FILE

# Add password file for dirsrv-admin
echo "internal:$PASS" > $ADMIN_PINFILE
chown dirsrv:dirsrv $ADMIN_PINFILE
chmod 400 $ADMIN_PINFILE

# Make admin-serv use the passphrase file while retaining file permissions
cp $ADMIN_DBPATH/nss.conf $ADMIN_DBPATH/nss.conf.dist
cat $SOURCE_DIR/nss.conf > $ADMIN_DBPATH/nss.conf

# Enable TLS in the Administration Server config
sed -i s/"configuration.nsServerSecurity: off"/"configuration.nsServerSecurity: on"/g $ADMIN_DBPATH/local.conf
sed -i s/"NSSEngine off"/"NSSEngine on"/g $ADMIN_DBPATH/console.conf

systemctl start dirsrv-admin
