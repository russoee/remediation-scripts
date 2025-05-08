#!/bin/bash

###############################################################################
# .SYNOPSIS
#   Installs, initializes, and configures AIDE for STIG compliance.
#
# .DESCRIPTION
#   Addresses the following STIGs:
#   - UBTU-24-100100: AIDE must be installed
#   - UBTU-24-100110: AIDE must be initialized
#   - UBTU-24-100130: AIDE must notify if configs are altered
#
# .NOTES
#   Author       : Eric Russo
#   STIG IDs     : UBTU-24-100100, 100110, 100130
#   Date Created : 2025-05-06
#   Version      : 1.1
#
# .USAGE
#   sudo ./UBTU-24-100100_aide-install-init.sh
#
# .TESTED ON
#   OS           : Ubuntu 24.04 LTS
#
###############################################################################

if [ "$EUID" -ne 0 ]; then
  echo "[-] This script must be run as root."
  exit 1
fi

echo "[+] Installing AIDE package..."
apt update && apt install -y aide

echo "[+] Initializing AIDE database (this may take a few minutes)..."
aideinit

echo "[+] Replacing new AIDE DB as the active baseline..."
cp -p /var/lib/aide/aide.db.new /var/lib/aide/aide.db

echo "[+] Verifying AIDE installation with manual check..."
aide -c /etc/aide/aide.conf --check

echo "[+] Configuring AIDE notifications..."
AIDE_DEFAULTS="/etc/default/aide"
if grep -q "^SILENTREPORTS=" "$AIDE_DEFAULTS"; then
  sed -i 's/^SILENTREPORTS=.*/SILENTREPORTS=no/' "$AIDE_DEFAULTS"
else
  echo "SILENTREPORTS=no" >> "$AIDE_DEFAULTS"
fi

echo "[✔] AIDE installation, initialization, and notification config complete."
