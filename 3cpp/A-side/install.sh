#!/bin/sh

SCRIPTPATH=$(dirname "$0")

cd ${SCRIPTPATH}
set -e
mkdir -p /etc/sipp
cp -f 3pcc-C-A.xml /etc/sipp/3pcc-C-A.xml
cp -f 3pcc-C-B.xml /etc/sipp/3pcc-C-B.xml
cp -f 3pcc-C-B.service /etc/systemd/system/3pcc-C-B.service
cp public.xml /etc/freeswitch/dialplan/public.xml
cp -f ../sipp-tmpfiles.conf /etc/tmpfiles.d/sipp.conf
cp check_pin.lua /usr/share/freeswitch/scripts/check_pin.lua

echo "Updating FreeSwitch listening ports"
sed -i -e 's/_sip_port=50/_sip_port=150/' /etc/freeswitch/vars.xml

if [ ! -f /etc/sipp/env ]; then
    cp ../env /etc/sipp/env
else
    echo File "/etc/sipp/env" already exist in system. Will be used current.
fi

if [ ! -f /etc/sipp/data.csv ]; then
    cp ../data.csv /etc/sipp/data.csv
else
    echo File "/etc/sipp/data.csv" already exist in system. Will be used current.
fi

systemctl daemon-reload
systemctl enable 3pcc-C-B.service
systemd-tmpfiles --create sipp.conf

exit 0

