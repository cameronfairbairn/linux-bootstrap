#!/bin/bash

# Define the URL to your public key
PUBLIC_KEY_URL="https://github.com/cameronfairbairn.keys"

# Clean up any existing user and configuration
sudo deluser --remove-home cameron-fairbairn
sudo rm -f /etc/sudoers.d/cameron-fairbairn

# Create the user and add to sudo group
sudo adduser --disabled-password --gecos "" cameron-fairbairn
sudo usermod -aG sudo cameron-fairbairn

# Set up SSH key-based authentication
sudo mkdir -p /home/cameron-fairbairn/.ssh
sudo curl -L $PUBLIC_KEY_URL -o /home/cameron-fairbairn/.ssh/authorized_keys

# Set correct permissions
sudo chown -R cameron-fairbairn:cameron-fairbairn /home/cameron-fairbairn/.ssh
sudo chmod 700 /home/cameron-fairbairn/.ssh
sudo chmod 600 /home/cameron-fairbairn/.ssh/authorized_keys

# Ensure SSH key-based authentication is enabled
sudo sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config
sudo sed -i 's/#AuthorizedKeysFile/AuthorizedKeysFile/' /etc/ssh/sshd_config

# Allow the user to run sudo without a password
echo 'cameron-fairbairn ALL=(ALL) NOPASSWD:ALL' | sudo tee /etc/sudoers.d/cameron-fairbairn

# Restart SSH service
sudo systemctl restart sshd

echo "User cameron-fairbairn has been created and configured successfully."

# Clean up this script
rm -- "$0"
