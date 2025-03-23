#!/bin/bash

master_ip=$(terraform output -json master_ip | jq -r '.') && echo $master_ip
slave_ips=$(terraform output -json slaves_ips | jq -r '.[]') && echo $slave_ips

touch inventory.ini

echo "[master]" >> inventory.ini
echo "$master_ip ansible_ssh_user=ubuntu ansible_ssh_private_key_file=./ssh-key" >> inventory.ini

echo "[slaves]" >> inventory.ini
for ip in $slave_ips; do
  echo "$ip ansible_ssh_user=ubuntu ansible_ssh_private_key_file=./ssh-key" >> inventory.ini
done

echo "Ansible inventory file created"
cat inventory.ini
