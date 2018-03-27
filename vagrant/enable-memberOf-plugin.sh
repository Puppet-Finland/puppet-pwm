#!/bin/sh
#
# Enable memberOf plugin
#
SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")

. $SCRIPTPATH/vars

ldapmodify $CONNECTION_PARAMS -D "$ROOTDN" -w $ROOTDN_PASS -x -f $SOURCE_DIR/memberOf.ldif

# memberOf plugin will not be active until the Directory Server instance is restarted
systemctl restart dirsrv@$INSTANCE
