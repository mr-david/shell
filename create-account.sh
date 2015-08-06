#!/bin/bash

PATH="/usr/sbin:/bin:/usr/bin"

if [ $# -ne 1 ]; then
        echo "usage: create.sh next-available-uid"
        exit 1
fi

uid=$1
partner=(account1 account2 account3)
last=${#partner[@]}

echo "starting at uid $uid"
echo "ending at uid $last"
echo "list of partners to add: ${partner[@]}"
echo -n "Is this correct [yes or no]? "
read answer
if [ "$answer" != "yes" ]; then
    echo "exiting"
    exit 1
fi

for ((i=0; i<$last; i++))
do
    useradd -u $((i+uid)) -G chrooted -c "${partner[$i]}" ${partner[$i]}
    mkdir -p /home/${partner[$i]}
    chown ${partner[$i]}.${partner[$i]} /home/${partner[$i]}
    pass=$(cat /dev/urandom|tr -dc "a-zA-Z0-9-_\$\?&*@#%^&()+!=|,." | fold -w 9 | head -1)
    echo "${partner[$i]}:${pass}" | chpasswd
    echo "${partner[$i]}:${pass}"
done
