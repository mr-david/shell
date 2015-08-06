#!/bin/bash

PATH="/usr/sbin:/bin:/usr/bin"

if [ $# -ne 1 ]; then
    echo "usage: create.sh next-available-uid"
    exit 1
fi

uid=$1
newuser=(account1 account2 account3)
last=${#newuser[@]}

echo "starting at uid $uid"
echo "ending at uid $last"
echo "list of newusers to add: ${newuser[@]}"
echo -n "Is this correct [yes or no]? "
read answer
if [ "$answer" != "yes" ]; then
    echo "exiting"
    exit 1
fi

for ((i=0; i<$last; i++))
do
    useradd -u $((i+uid)) -G chrooted -c "${newuser[$i]}" ${newuser[$i]}
    mkdir -p /chroot/${newuser[$i]}
    chown ${newuser[$i]}.${newuser[$i]} /chroot/${newuser[$i]}
    pass=$(cat /dev/urandom|tr -dc "a-zA-Z0-9-_\$\?&*@#%^&()+!=|,." | fold -w 9 | head -1)
    echo "${newuser[$i]}:${pass}" | chpasswd
    echo "${newuser[$i]}:${pass}"
done
