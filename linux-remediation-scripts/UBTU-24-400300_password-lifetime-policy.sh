#!/bin/bash

###############################################################################
# .SYNOPSIS
#   Configures password aging policy in /etc/login.defs
#
# .DESCRIPTION
#   Remediates the following STIGs:
#   - UBTU-24-400300: PASS_MIN_DAYS must be 1
#   - UBTU-24-400310: PASS_MAX_DAYS must be 60
#
# .NOTES
#   Author       : Eric Russo
#   Date Created : 2025-05-06
#   Version      : 1.0
#
# .USAGE
#   sudo ./UBTU-24-400300_password-lifetime-policy.sh
#
# .TESTED ON
#   OS           : Ubuntu 24.04 LTS
#
###############################################################################

CONF_FILE="/etc/login.defs"

if [ "$EUID" -ne 0 ]; then
  echo "[-] Script must be run as root. Exiting."
  exit 1
fi

echo "[+] Setting password aging policy in $CONF_FILE..."

update_or_append_setting() {
  KEY="$1"
  VALUE="$2"
  if grep -q "^$KEY" "$CONF_FILE"; then
    sed -i "s/^$KEY.*/$KEY    $VALUE/" "$CONF_FILE"
    echo "[✔] Updated: $KEY = $VALUE"
  else
    echo "$KEY    $VALUE" >> "$CONF_FILE"
    echo "[✔] Added: $KEY = $VALUE"
  fi
}

update_or_append_setting "PASS_MIN_DAYS" "1"
update_or_append_setting "PASS_MAX_DAYS" "60"

echo "[✔] Password aging policy set successfully."
