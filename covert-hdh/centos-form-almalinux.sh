#!/bin/bash
sudo yum update -y
sudo yum install -y http://repo.almalinux.org/elevate/elevate-release-latest-el7.noarch.rpm
sudo yum install -y leapp-upgrade leapp-data-almalinux
sudo rmmod pata_acpi
echo PermitRootLogin yes | sudo tee -a /etc/ssh/sshd_config
sudo leapp answer --section remove_pam_pkcs11_module_check.confirm=True
sudo leapp upgrade
sudo reboot

