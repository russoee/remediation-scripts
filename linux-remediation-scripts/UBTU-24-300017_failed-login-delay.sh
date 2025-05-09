#!/bin/bash

###############################################################################
# .SYNOPSIS
#   Configures failed login delay using pam_faildelay.so.
#
# .DESCRIPTION
#   Remediates UBTU-24-300017 by enforcing a 4-second delay on failed logins.
#
# .NOTES
#   Author       : Eric Russo
#   STIG ID      : UBTU-24-300017
#   Date Created : 2025-05-06
#   Version      : 1.0
#
# .USAGE
#   sudo ./UBTU-24-300017_failed-login-delay.sh
#
# .TESTED ON
#   OS           : Ubuntu 24.04 LTS
#
###############################################################################

PAM_FILE="/etc/pam.d/common-auth"
REQUIRED_LINE="auth required pam_faildelay.so delay=4000000"

if [ "$EUID" -ne 0 ]; then
  echo "[-] Script must be run as root."
  exit 1
fi

echo "[+] Checking for existing pam_faildelay rule..."

if grep -q "pam_faildelay.so" "$PAM_FILE"; then
  echo "[!] Existing pam_faildelay line found. Updating to required delay..."
  sed -i '/pam_faildelay.so/c\'"$REQUIRED_LINE" "$PAM_FILE"
else
  echo "[+] Adding delay rule to the top of $PAM_FILE..."
  sed -i "1i$REQUIRED_LINE" "$PAM_FILE"
fi

echo "[✔] Failed login delay of 4 seconds has been applied."
