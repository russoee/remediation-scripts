#!/bin/bash

###############################################################################
# .SYNOPSIS
#   Configures password complexity requirements using /etc/security/pwquality.conf
#
# .DESCRIPTION
#   Enforces multiple DISA STIG requirements related to password complexity:
#   - UBTU-24-400260: Require uppercase characters
#   - UBTU-24-400270: Require lowercase characters
#   - UBTU-24-400280: Require digits
#   - UBTU-24-400290: Require changed characters
#   - UBTU-24-400320: Enforce minimum password length
#   - UBTU-24-400330: Require special characters
#
# .NOTES
#   Author       : Eric Russo
#   STIG IDs     : UBTU-24-400260, 400270, 400280, 400290, 400320, 400330
#   Date Created : 2025-05-06
#   Version      : 1.0
#
# .USAGE
#   sudo ./UBTU-24-400260_pwquality-complexity.sh
#
# .TESTED ON
#   OS           : Ubuntu 24.04 LTS
#
###############################################################################

if [ "$EUID" -ne 0 ]; then
  echo "[-] This script must be run as root. Exiting."
  exit 1
fi

CONF_FILE="/etc/security/pwquality.conf"

echo "[+] Configuring $CONF_FILE with required complexity parameters..."

declare -A settings=(
  ["ucredit"]="-1"
  ["lcredit"]="-1"
  ["dcredit"]="-1"
  ["ocredit"]="-1"
  ["difok"]="8"
  ["minlen"]="15"
)

for key in "${!settings[@]}"; do
  if grep -q "^$key" "$CONF_FILE"; then
    sed -i "s/^$key.*/$key = ${settings[$key]}/" "$CONF_FILE"
    echo "[✔] Updated: $key = ${settings[$key]}"
  else
    echo "$key = ${settings[$key]}" >> "$CONF_FILE"
    echo "[✔] Added: $key = ${settings[$key]}"
  fi
done

echo "[✔] Password complexity policy configured successfully."
