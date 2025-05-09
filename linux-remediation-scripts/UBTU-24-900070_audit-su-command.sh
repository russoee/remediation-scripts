#!/bin/bash

###############################################################################
# .SYNOPSIS
#   Ensures audit records are generated for use of the 'su' command.
#
# .DESCRIPTION
#   Remediates UBTU-24-900070 by creating an audit rule for /bin/su.
#
# .NOTES
#   Author       : Eric Russo
#   STIG ID      : UBTU-24-900070
#   Date Created : 2025-05-06
#   Version      : 1.0
#
# .USAGE
#   sudo ./UBTU-24-900070_audit-su-command.sh
#
# .TESTED ON
#   OS           : Ubuntu 24.04 LTS
#
###############################################################################

RULE_FILE="/etc/audit/rules.d/stig.rules"
RULE='-a always,exit -F path=/bin/su -F perm=x -F auid>=1000 -F auid!=-1 -k privileged-priv_change'

# Check for root
if [ "$EUID" -ne 0 ]; then
  echo "[-] This script must be run as root."
  exit 1
fi

echo "[+] Ensuring audit rule for /bin/su is present..."

# Create the rules file if missing
if [ ! -f "$RULE_FILE" ]; then
  touch "$RULE_FILE"
fi

# Check if rule already exists
if grep -Fq "$RULE" "$RULE_FILE"; then
  echo "[✔] Rule already present. No changes made."
else
  echo "$RULE" >> "$RULE_FILE"
  echo "[+] Rule added to $RULE_FILE"
fi

echo "[+] Reloading audit rules..."
augenrules --load

echo "[✔] Audit rule for 'su' command successfully applied."
