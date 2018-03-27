#!/bin/sh
#
# Enable TLS using a self-signed SSL certificate. Adapted from here:
#
# https://access.redhat.com/documentation/en-us/red_hat_directory_server/10/html/administration_guide/enabling_tls
#
SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")

. $SCRIPTPATH/vars

echo "$PK12PASS" > $PASSFILE
openssl rand -out $NOISE 4096
certutil -f $PASSFILE -d $DBPATH -N
certutil -f $PASSFILE -S -x -d $DBPATH -z $NOISE -n "server-cert" -s "CN=$HOSTNAME" -t "CT,C,C" -m $RANDOM --keyUsage digitalSignature,nonRepudiation,keyEncipherment,dataEncipherment
rm -f $NOISE
chown dirsrv:dirsrv $DBPATH/*.db
chmod 600 $DBPATH/*.db

# Ensure that dirsrv does not prompt for password when it restarts
echo "Internal (Software) Token:$PK12PASS" > $PINFILE
chown dirsrv:dirsrv $PINFILE
chmod 400 $PINFILE

# Ensure that we can ldapadd/ldapmodify
systemctl start dirsrv@$INSTANCE

# Enable TLS and set the LDAPS port for Directory Server
ldapmodify $CONNECTION_PARAMS -D "$ROOTDN" -w $ROOTDN_PASS -x -f $SOURCE_DIR/ldap-tls.ldif

# Enable TLS for Connections from the Console to Directory Server
ldapmodify $CONNECTION_PARAMS -D "$ROOTDN" -w $ROOTDN_PASS -x -f $SOURCE_DIR/console-dirsrv.ldif

# Enable RSA
ldapadd $CONNECTION_PARAMS -D "$ROOTDN" -w $ROOTDN_PASS -x -f $SOURCE_DIR/rsa.ldif
