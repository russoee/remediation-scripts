#!/bin/bash

###############################################################################
# .SYNOPSIS
#   Configures pwquality and PAM to enforce password complexity rules.
#
# .DESCRIPTION
#   Addresses the following STIGs:
#   - UBTU-24-300014: Prevent use of dictionary words in passwords
#   - UBTU-24-300016: Enforce password complexity using pwquality and PAM
#
# .NOTES
#   Author       : Eric Russo
#   STIG IDs     : UBTU-24-300014, 300016
#   Date Created : 2025-05-06
#   Version      : 1.0
#
# .USAGE
#   sudo ./UBTU-24-300014_pwquality-password-controls.sh
#
# .TESTED ON
#   OS           : Ubuntu 24.04 LTS
#
###############################################################################

if [ "$EUID" -ne 0 ]; then
  echo "[-] Must be run as root."
  exit 1
fi

PWQUALITY_CONF="/etc/security/pwquality.conf"
PAM_FILE="/etc/pam.d/common-password"

echo "[+] Updating $PWQUALITY_CONF..."

# Set dictcheck=1
if grep -q "^dictcheck=" "$PWQUALITY_CONF"; then
  sed -i 's/^dictcheck=.*/dictcheck=1/' "$PWQUALITY_CONF"
else
  echo "dictcheck=1" >> "$PWQUALITY_CONF"
fi

# Set enforcing=1
if grep -q "^enforcing=" "$PWQUALITY_CONF"; then
  sed -i 's/^enforcing=.*/enforcing=1/' "$PWQUALITY_CONF"
else
  echo "enforcing=1" >> "$PWQUALITY_CONF"
fi

echo "[+] Updating $PAM_FILE..."

# Ensure password requisite line for pam_pwquality exists and is properly set
if grep -q "^password\s\+requisite\s\+pam_pwquality.so" "$PAM_FILE"; then
  sed -i 's/^password\s\+requisite\s\+pam_pwquality.so.*/password requisite pam_pwquality.so retry=3/' "$PAM_FILE"
else
  echo "password requisite pam_pwquality.so retry=3" >> "$PAM_FILE"
fi

echo "[✔] Password complexity settings applied per STIGs 300014 and 300016."
