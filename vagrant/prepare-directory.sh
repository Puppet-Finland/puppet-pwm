#!/bin/sh
#
# Prepare 389 Directory Server for use with Pwm
#
PATH=/bin:/sbin:/usr/bin:/usr/sbin
DBPATH="/etc/dirsrv/slapd-vagrant"
ADMIN_DBPATH="/etc/dirsrv/admin-serv"
PINFILE="$DBPATH/pin.txt"
ADMIN_PINFILE="$ADMIN_DBPATH/pin.txt"
PASSFILE="/tmp/pass"
PK12FILE="/tmp/keys.pk12"
PASS="vagrant"
NOISE="/tmp/noise"
NSS_CONF="$ADMIN_DBPATH/nss.conf"

# Do not pull the carpet from beneath 389ds
systemctl stop dirsrv@vagrant

# Cleanup to allow multiple consecutive runs
rm -f $ADMIN_DBPATH/*.db $DBPATH/*.db $PINFILE $PASSFILE

# Import a minimal database (dc=example,dc=org) modified to work with Pwm
ldif2db -Z vagrant -s 'dc=example,dc=org' -i /vagrant/vagrant/example.org.ldif

# Enable TLS using a self-signed SSL certificate. Adapted from here:
#
# https://access.redhat.com/documentation/en-us/red_hat_directory_server/10/html/administration_guide/enabling_tls
#
# Create a temporary password file
echo "$PASS" > $PASSFILE
openssl rand -out $NOISE 4096
certutil -f $PASSFILE -d $DBPATH -N
certutil -f $PASSFILE -S -x -d $DBPATH -z $NOISE -n "server-cert" -s "CN=$HOSTNAME" -t "CT,C,C" -m $RANDOM --keyUsage digitalSignature,nonRepudiation,keyEncipherment,dataEncipherment
rm -f $NOISE
chown dirsrv:dirsrv $DBPATH/*.db
chmod 600 $DBPATH/*.db

# Ensure that dirsrv does not prompt for password when it restarts
echo "Internal (Software) Token:$PASS" > $PINFILE
chown dirsrv:dirsrv $PINFILE
chmod 400 $PINFILE

# Start the directory server so that we can ldapmodify/add
systemctl start dirsrv@vagrant

# Enable memberOf plugin
ldapmodify -D "cn=Directory Manager" -w $PASS -p 389 -h pwm-dirsrv.local -x -f /vagrant/vagrant/memberOf.ldif

# Enable TLS and set the LDAPS port for Directory Server
ldapmodify -D "cn=Directory Manager" -w $PASS -p 389 -h pwm-dirsrv.local -x -f /vagrant/vagrant/ldap-tls.ldif

# Enable TLS for Connections from the Console to Directory Server
ldapmodify -D "cn=Directory Manager" -w $PASS -p 389 -h pwm-dirsrv.local -x -f /vagrant/vagrant/console-dirsrv.ldif

# Enable RSA
ldapadd -D "cn=Directory Manager" -w $PASS -p 389 -h pwm-dirsrv.local -x -f /vagrant/vagrant/rsa.ldif

# Restart to activate the memberOf plugin
systemctl restart dirsrv@vagrant

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
cat /vagrant/vagrant/nss.conf > $ADMIN_DBPATH/nss.conf

# Enable TLS in the Administration Server config
sed -i s/"configuration.nsServerSecurity: off"/"configuration.nsServerSecurity: on"/g $ADMIN_DBPATH/local.conf
sed -i s/"NSSEngine off"/"NSSEngine on"/g $ADMIN_DBPATH/console.conf

systemctl start dirsrv-admin

