Polkadot Node Scripts

A collection of scripts for monitoring, auditing, and managing Polkadot nodes. Scripts are organized by operating system and purpose.

Contents

RHEL/CentOS
Scripts designed for RHEL-based distributions (RHEL, CentOS, AlmaLinux, Rocky Linux). Example: system info, node health checks, firewall setup.

Ubuntu/Debian
Scripts tailored for Debian-based distributions. Example: system info, monitoring setup, network checks.

Multi-Platform
Scripts compatible with multiple Linux distributions. Example: node log parsing, automated backups, security checks.

Usage

1. Make sure you have the Polkadot node built and located at:
/home/<your_user>/polkadot-sdk/target/release/polkadot

2. Make the script executable:
chmod +x scriptKsmcc3.sh

3. Run the script:
./scriptKsmcc3.sh

4. Check the log output for any errors and verify that the benchmark completes successfully.

Contributing

Feel free to add scripts for new distributions or node-related tasks. Please follow the same structure and provide comments in English for clarity.
