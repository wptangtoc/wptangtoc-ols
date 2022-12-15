#!/bin/bash
mariadb=$(systemctl status redis.service | grep 'Active' | cut -f2 -d':' | xargs | cut -f1 -d' ' | xargs)
if [[ "$mariadb" != "active" ]]; then
systemctl restart mariadb.service
fi
