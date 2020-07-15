#!/bin/bash

HOST=1.1.1.1
if [ "$1" != "" ]; then
        HOST=$1
fi

echo "Installing to $HOST"
echo "/boot rw"
sshpass -p hifiberry ssh root@$HOST mount -o remount,rw /boot
echo "Copying file"
sshpass -p hifiberry scp kernel.tar root@$HOST:
echo "Extracting"
sshpass -p hifiberry ssh root@$HOST tar xvf kernel.tar -C /
echo "Rebooting"
sshpass -p hifiberry ssh root@$HOST reboot
