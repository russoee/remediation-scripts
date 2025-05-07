#!/bin/bash

###############################################################################
# .SYNOPSIS
#   Enables auditd and loads audit rules to meet STIG UBTU-24-100410.
#
# .DESCRIPTION
#   Ensures auditd is enabled on boot and audit rules are loaded properly.
#
# .NOTES
#   Author       : Eric Russo
#   STIG ID      : UBTU-24-100410
#   Date Created : 2025-05-06
#   Version      : 1.1
#
# .USAGE
#   sudo ./UBTU-24-100410_auditd-enable-and-load-rules.sh
#
# .TESTED ON
#   OS           : Ubuntu 24.04 LTS
#
###############################################################################

if [ "$EUID" -ne 0 ]; then
  echo "[-] This script must be run as root. Exiting."
  exit 1
fi

echo "[+] Enabling auditd service..."
systemctl enable auditd

echo "[+] Reloading audit rules from /etc/audit/rules.d/..."
augenrules --load

echo "[✔] auditd is enabled and rules are loaded."
