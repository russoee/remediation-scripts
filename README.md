# Remediation Scripts Portfolio

This repository contains security hardening and compliance remediation scripts I've developed and tested across lab environments. These scripts focus on aligning systems with recognized baselines, including DISA STIGs and operational best practices.

## Structure

- `windows-stig-remediation/`  
  PowerShell scripts that automate remediation of Windows 10 and Windows Server 2019 STIG findings. Each script is named by STIG ID and includes metadata headers and verification steps.

- `linux-stig-remediation/` 
  Bash scripts designed to bring Linux systems (Ubuntu 24.04) into alignment with applicable STIG recommendations or CIS controls.

  Scripts are organized by **functional area**, not strictly one-to-one with STIG IDs. This reflects the reality that multiple STIGs often converge around a single tool or configuration (e.g., SSH hardening or AIDE setup). Each script is named by primary STIG ID and includes:

  - Metadata headers (author, STIG ID(s), synopsis, usage, OS tested)
  - Verification logic and safe defaults
  - Inline comments and structure for operational clarity

  **Examples:**
  - `UBTU-24-100810-100860_ssh-fips-hardening.sh` addresses six SSH-related STIGs by locking down server and client configurations to FIPS 140-3 approved crypto.
  - `UBTU-24-100100-100130_aide-install-init.sh` installs, initializes, and configures AIDE, covering three file integrity-related STIGs.

  This design mirrors realistic system hardening workflows used by operations and compliance teams in enterprise and government environments.

- `cyber-range-scripts/`  
  A collection of utility scripts and automation used in lab environments, including threat simulation, data collection, and exploratory scripting (e.g., Tenable, Defender EDR, Pi-hole DNS logging).

## About the Scripts

Each remediation script is:

- Mapped to an official STIG ID or policy recommendation
- Written to be idempotent and safe to rerun
- Includes metadata, usage instructions, and verification checks

## ⚠️ Disclaimer

These scripts are developed and tested in isolated lab environments. Always validate before use in production.

---

> 🧑‍💻 Maintained by [Eric Russo](https://github.com/russoee)
