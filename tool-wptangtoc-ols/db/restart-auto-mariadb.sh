#!/bin/bash
mariadb=$(systemctl status mysql.service | grep 'Active' | cut -f2 -d':' | xargs | cut -f1 -d' ' | xargs)
if [[ "$mariadb" != "active" ]]; then
systemctl restart mariadb.service
fi
