#!/bin/bash

###############################################################################
# .SYNOPSIS
#   Adds audit rules for permission and ownership change syscalls.
#
# .DESCRIPTION
#   Remediates:
#   - UBTU-24-900140 (chown/fchown/etc)
#   - UBTU-24-900150 (chmod/fchmod/etc)
#
# .NOTES
#   Author       : Eric Russo
#   Date Created : 2025-05-06
#   Version      : 1.0
#
# .USAGE
#   sudo ./UBTU-24-900140_permission-change-syscalls.sh
#
# .TESTED ON
#   OS           : Ubuntu 24.04 LTS
#
###############################################################################

RULE_FILE="/etc/audit/rules.d/stig.rules"

if [ "$EUID" -ne 0 ]; then
  echo "[-] Must be run as root."
  exit 1
fi

echo "[+] Adding syscall audit rules to $RULE_FILE..."

declare -a RULES=(
  "-a always,exit -F arch=b32 -S chown,fchown,fchownat,lchown -F auid>=1000 -F auid!=-1 -k perm_chng"
  "-a always,exit -F arch=b64 -S chown,fchown,fchownat,lchown -F auid>=1000 -F auid!=-1 -k perm_chng"
  "-a always,exit -F arch=b32 -S chmod,fchmod,fchmodat -F auid>=1000 -F auid!=-1 -k perm_chng"
  "-a always,exit -F arch=b64 -S chmod,fchmod,fchmodat -F auid>=1000 -F auid!=-1 -k perm_chng"
)

# Create file if missing
if [ ! -f "$RULE_FILE" ]; then
  touch "$RULE_FILE"
fi

# Add any rules that are not already present
for RULE in "${RULES[@]}"; do
  if grep -Fq "$RULE" "$RULE_FILE"; then
    echo "[✔] Rule already present: $RULE"
  else
    echo "$RULE" >> "$RULE_FILE"
    echo "[+] Rule added: $RULE"
  fi
done

echo "[+] Reloading audit rules with augenrules..."
augenrules --load

echo "[✔] Audit syscall rules for chown/chmod families applied successfully."
