#!/bin/sh

SCRIPTPATH=$(dirname "$0")

cd ${SCRIPTPATH}
set -e
set -x
systemctl restart 3pcc-C-B.service

LOCALIP=$(grep -o -P '(?<=IP=)[0-9a-f:.]+' /etc/sipp/env)
if [ -z "${LOCALIP}" ]; then
    echo Error: local IP address is not configured in /etc/sipp/env file. Exiting
    exit 1
fi

echo -n "Reloading FreeSwitch sofia module: "
#fs_cli -x "reload mod_sofia"

cd /opt/freeswitch
ln -fs /etc/sipp/3pcc-C-A.xml
sipp -sf 3pcc-C-A.xml \
     -inf /etc/sipp/data.csv \
     -3pcc localhost:7777\
     -r 1 \
     -p 15083 \
     -trace_err \
     -trace_screen \
     -i ${LOCALIP} \
     ${LOCALIP}:15080

exit 0

