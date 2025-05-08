#!/bin/bash

###############################################################################
# .SYNOPSIS
#   Hardens SSH server and client to meet STIG FIPS 140-3 crypto requirements.
#
# .DESCRIPTION
#   Applies specific Ciphers, MACs, and KexAlgorithms to comply with:
#   - UBTU-24-100810, 100820, 100830, 100840, 100850, 100860
#
# .NOTES
#   Author       : Eric Russo
#   STIG IDs     : UBTU-24-100810 to 100860
#   Date Created : 2025-05-06
#   Version      : 1.1 (Tenable-aligned)
#
# .USAGE
#   sudo ./UBTU-24-100810-100860_ssh-fips-hardening.sh
#
# .TESTED ON
#   OS           : Ubuntu 24.04 LTS
#
###############################################################################

if [ "$EUID" -ne 0 ]; then
  echo "[-] Must be run as root."
  exit 1
fi

SSHD_CONFIG="/etc/ssh/sshd_config"
SSH_CONFIG="/etc/ssh/ssh_config"

# Backup existing configs
echo "[+] Backing up sshd_config and ssh_config..."
cp "$SSHD_CONFIG" "${SSHD_CONFIG}.bak"
cp "$SSH_CONFIG" "${SSH_CONFIG}.bak"

# Apply server-side (daemon) hardening
echo "[+] Updating SSH daemon (server) config..."

sed -i '/^Ciphers/d' "$SSHD_CONFIG"
sed -i '/^MACs/d' "$SSHD_CONFIG"
sed -i '/^KexAlgorithms/d' "$SSHD_CONFIG"

echo "Ciphers aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes128-ctr" >> "$SSHD_CONFIG"
echo "MACs hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com,hmac-sha2-512,hmac-sha2-256" >> "$SSHD_CONFIG"
echo "KexAlgorithms ecdh-sha2-nistp521,ecdh-sha2-nistp384,ecdh-sha2-nistp256,diffie-hellman-group-exchange-sha256,diffie-hellman-group16-sha512,diffie-hellman-group14-sha256" >> "$SSHD_CONFIG"

# Apply client-side hardening
echo "[+] Updating SSH client config..."

sed -i '/^Ciphers/d' "$SSH_CONFIG"
sed -i '/^MACs/d' "$SSH_CONFIG"

echo "Ciphers aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes128-ctr" >> "$SSH_CONFIG"
echo "MACs hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com,hmac-sha2-512,hmac-sha2-256" >> "$SSH_CONFIG"

# Enable and start ssh service
echo "[+] Enabling and starting SSH service..."
systemctl enable ssh
systemctl start ssh

# Restart SSH service to apply config
echo "[+] Restarting SSH service..."
systemctl restart ssh

echo "[✔] SSH FIPS hardening applied and service restarted."
