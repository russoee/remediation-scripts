# Remediation Scripts Portfolio

This repository contains security hardening and compliance remediation scripts I've developed and tested across lab environments. These scripts focus on aligning systems with recognized baselines, including DISA STIGs and operational best practices.

## Structure

- `windows-stig-remediation/`  
  PowerShell scripts that automate remediation of Windows 10 and Windows Server 2019 STIG findings. Each script is named by STIG ID and includes metadata headers and verification steps.

- `linux-stig-remediation/`  
  (Coming soon) – Bash scripts designed to bring Linux systems (Ubuntu 24.04) into alignment with applicable STIG recommendations or CIS controls.

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
