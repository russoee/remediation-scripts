#!/bin/bash

###############################################################################
# .SYNOPSIS
#   Installs and enables auditd for DISA STIG compliance on Ubuntu 24.04 LTS.
#
# .DESCRIPTION
#   UBTU-24-100400 - Ubuntu 24.04 LTS must have the "auditd" package installed.
#   This script installs the required packages, enables auditd, and ensures
#   the service is running to support security event auditing.
#
# .NOTES
#   Author       : Eric Russo
#   STIG ID      : UBTU-24-100400
#   Date Created : 2025-05-06
#   Version      : 1.0
#
# .USAGE
#   sudo ./UBTU-24-100400_remediation.sh
#
# .TESTED ON
#   OS           : Ubuntu 24.04 LTS
#
###############################################################################

# Ensure script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "[-] This script must be run as root. Exiting."
  exit 1
fi

echo "[+] Installing auditd and required plugins..."
apt update && apt install -y auditd audispd-plugins

echo "[+] Enabling auditd service at boot..."
systemctl enable auditd

echo "[+] Starting auditd service..."
systemctl start auditd

# Verify status
if systemctl is-active --quiet auditd; then
  echo "[+] auditd service is running and enabled."
else
  echo "[-] auditd failed to start. Please investigate manually."
  exit 1
fi

echo "[✔] Remediation for UBTU-24-100400 completed successfully."
