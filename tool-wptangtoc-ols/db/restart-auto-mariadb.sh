#!/bin/bash
. /etc/wptt/core-functions 2>/dev/null
mariadb=$(systemctl status mysql.service | grep 'Active' | cut -f2 -d':' | xargs | cut -f1 -d' ' | xargs)
if [[ "$mariadb" != "active" ]]; then
systemctl restart mariadb.service
fi
