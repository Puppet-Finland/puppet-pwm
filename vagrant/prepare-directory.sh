#!/bin/sh
#
# Prepare 389 Directory Server for use with Pwm
#
PATH=/bin:/sbin:/usr/bin:/usr/sbin
DBPATH="/etc/dirsrv/slapd-vagrant"
ADMIN_DBPATH="/etc/dirsrv/admin-serv"
PINFILE="$DBPATH/pin.txt"
PASSFILE="/tmp/pass"
PK12FILE="/tmp/keys.pk12"
PASS="vagrant"
NOISE="/tmp/noise"

# Do not pull the carpet from beneath 389ds
systemctl stop dirsrv@vagrant

# Cleanup to allow multiple consecutive runs
rm -f $ADMIN_DBPATH/*.db $DBPATH/*.db $PINFILE $PASSFILE

# Import a minimal database (dc=example,dc=org) modified to work with Pwm
ldif2db -Z vagrant -s 'dc=example,dc=org' -i /vagrant/vagrant/example.org.ldif

# Ensure that dirsrv does not prompt for password when it restarts
echo "Internal (Software) Token:$PASS" > $PINFILE
chown dirsrv:dirsrv $PINFILE
chmod 400 $PINFILE

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

# Start the directory server so that we can ldapmodify/add
systemctl start dirsrv@vagrant

# Enable various features:
#
# - memberOf plugin
# - TLS for LDAP connections
# - TLS for admin connections
#
for i in memberOf ldap-tls admin-tls; do
    ldapmodify -D "cn=Directory Manager" -w $PASS -p 389 -h pwm-dirsrv.local -x -f /vagrant/vagrant/$i.ldif
done

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

systemctl start dirsrv-admin
