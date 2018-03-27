#!/bin/sh
#
# Enable TLS for the Admin server by reusing Directory Server certificates
#
SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")

. $SCRIPTPATH/vars

systemctl stop dirsrv-admin

# Reuse directory server cert/key for the admin server
pk12util -o $PK12FILE -n server-cert -W $PK12PASS -K $PK12PASS -d $DBPATH
pk12util -i $PK12FILE -d /etc/dirsrv/admin-serv/ -W $PK12PASS -K $PK12PASS

chown dirsrv:dirsrv $ADMIN_DBPATH/*.db
chmod 600 $ADMIN_DBPATH/*.db

rm -f $PK12FILE

# Add password file for dirsrv-admin
echo "internal:$PK12PASS" > $ADMIN_PINFILE
chown dirsrv:dirsrv $ADMIN_PINFILE
chmod 400 $ADMIN_PINFILE

# Make admin-serv use the passphrase file while retaining file permissions
cp -f $ADMIN_DBPATH/nss.conf $ADMIN_DBPATH/nss.conf.dist
cat $SOURCE_DIR/nss.conf > $ADMIN_DBPATH/nss.conf

# Enable TLS in the Administration Server config
sed -i s/"configuration.nsServerSecurity: off"/"configuration.nsServerSecurity: on"/g $ADMIN_DBPATH/local.conf
sed -i s/"NSSEngine off"/"NSSEngine on"/g $ADMIN_DBPATH/console.conf

systemctl start dirsrv-admin
