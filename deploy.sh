#!/bin/bash

set -e

# Variables
KEY_NAME="id_rsa"
KEY_PATH="$HOME/.ssh/$KEY_NAME"
PUB_KEY_PATH="${KEY_PATH}.pub"
COMMENT="minecraft-key"
INVENTORY_FILE="../ansible/inventory.ini"

# Generate SSH key if it doesn't exist
if [ ! -f "$KEY_PATH" ]; then
  echo "Generating SSH key..."
  ssh-keygen -t rsa -b 4096 -C "$COMMENT" -f "$KEY_PATH" -N ""
else
  echo "SSH key already exists at $KEY_PATH, using this key for initialization"
fi

# Navigate to the terraform directory
cd "$(dirname "$0")/terraform" || exit 1

# Run Terraform
echo "Running Terraform."
terraform init
terraform apply -auto-approve -var="public_key_path=${PUB_KEY_PATH}"

# Extract public IP
PUBLIC_IP=$(terraform output -raw public_ip)
echo "Public IP is: $PUBLIC_IP"

# Wait for EC2 instance to be SSH-accessible
echo "Waiting for SSH to become available on $PUBLIC_IP..."
while ! nc -z -w5 $PUBLIC_IP 22; do
  sleep 5
done

# Update Ansible inventory
echo "Updating Ansible inventory."
echo "[minecraft]" > "$INVENTORY_FILE"
echo "$PUBLIC_IP ansible_user=ec2-user ansible_ssh_private_key_file=$KEY_PATH" >> "$INVENTORY_FILE"

# Run Ansible playbook
echo "Running Ansible playbook."
ansible-playbook -i "$INVENTORY_FILE" ../ansible/playbook.yml