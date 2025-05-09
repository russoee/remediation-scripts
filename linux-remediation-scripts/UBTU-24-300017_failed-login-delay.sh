#!/bin/bash

###############################################################################
# .SYNOPSIS
#   Safely configures a 4-second failed login delay using pam_faildelay.so.
#
# .DESCRIPTION
#   Replaces any incorrectly placed pam_faildelay line and repositions it
#   directly after pam_unix.so, as required by PAM flow. Originally implemented as a static prepend to common-auth,
#   this version corrects placement to follow pam_unix.so to maintain PAM order integrity.
#
# .NOTES
#   Author       : Eric Russo
#   STIG ID      : UBTU-24-300017
#   Date Created : 2025-05-06
#   Version      : 1.1 (fixed order)
#
# .USAGE
#   sudo ./UBTU-24-300017_failed-login-delay.sh
#
# .TESTED ON
#   OS           : Ubuntu 24.04 LTS
#
###############################################################################

PAM_FILE="/etc/pam.d/common-auth"
DELAY_LINE="auth    required    pam_faildelay.so delay=4000000"

if [ "$EUID" -ne 0 ]; then
  echo "[-] Script must be run as root."
  exit 1
fi

echo "[+] Removing any existing pam_faildelay lines..."
sed -i '/pam_faildelay\.so/d' "$PAM_FILE"

echo "[+] Looking for pam_unix.so to insert delay after..."
LINE_NUM=$(grep -n "pam_unix.so" "$PAM_FILE" | cut -d: -f1 | head -n 1)

if [ -z "$LINE_NUM" ]; then
  echo "[-] pam_unix.so not found. Cannot apply fix."
  exit 1
fi

INSERT_LINE=$((LINE_NUM + 1))

echo "[+] Inserting delay rule after line $LINE_NUM..."
sed -i "${INSERT_LINE}i $DELAY_LINE" "$PAM_FILE"

echo "[+] Reloading SSH and audit rules..."
augenrules --load
systemctl restart ssh

echo "[✔] Delay of 4 seconds for failed logins has been safely applied."
