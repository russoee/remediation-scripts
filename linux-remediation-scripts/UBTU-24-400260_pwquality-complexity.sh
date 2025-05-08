#!/bin/bash

###############################################################################
# .SYNOPSIS
#   Configures password complexity requirements using pwquality.conf
#
# .DESCRIPTION
#   Remediates the following STIGs:
#   - UBTU-24-400260: Require uppercase characters
#   - UBTU-24-400270: Require lowercase characters
#   - UBTU-24-400280: Require digits
#   - UBTU-24-400290: Require difok = 8 (min changed characters)
#   - UBTU-24-400320: Require minlen = 15
#   - UBTU-24-400330: Require special characters
#
# .NOTES
#   Author       : Eric Russo
#   Date Created : 2025-05-06
#   Version      : 1.1 (portable syntax)
#
# .USAGE
#   sudo ./UBTU-24-400260_pwquality-complexity.sh
#
# .TESTED ON
#   OS           : Ubuntu 24.04 LTS
#
###############################################################################

CONF_FILE="/etc/security/pwquality.conf"

# Ensure we're running as root
if [ "$EUID" -ne 0 ]; then
  echo "[-] This script must be run as root."
  exit 1
fi

echo "[+] Updating $CONF_FILE with password complexity settings..."

update_or_append_setting() {
  KEY="$1"
  VALUE="$2"
  if grep -q "^$KEY" "$CONF_FILE"; then
    sed -i "s/^$KEY.*/$KEY = $VALUE/" "$CONF_FILE"
    echo "[✔] Updated: $KEY = $VALUE"
  else
    echo "$KEY = $VALUE" >> "$CONF_FILE"
    echo "[✔] Added: $KEY = $VALUE"
  fi
}

update_or_append_setting "ucredit" "-1"
update_or_append_setting "lcredit" "-1"
update_or_append_setting "dcredit" "-1"
update_or_append_setting "ocredit" "-1"
update_or_append_setting "difok" "8"
update_or_append_setting "minlen" "15"

echo "[✔] All password complexity parameters set successfully."
