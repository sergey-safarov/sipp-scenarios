#!/bin/sh

SCRIPTPATH=$(dirname "$0")

cd ${SCRIPTPATH}
set -e
systemctl restart 3pcc-C-B.service
systemctl restart 3pcc-C-A.service

echo -n "Reloading FreeSwitch sofia module: "
fs_cli -x "reload mod_sofia"

exit 0

