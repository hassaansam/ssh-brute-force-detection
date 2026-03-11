# SSH Brute Force Detection & Alert System

## Overview

This project is a **Bash-based security monitoring script** that detects potential **SSH brute force attacks** by analyzing failed login attempts in system logs.
When multiple failed login attempts are detected from the same IP address, the script generates an alert to notify the system administrator.

This tool can help system administrators quickly identify suspicious login activity and take action to secure their systems.

---

## Features

* Monitors SSH authentication logs
* Detects repeated failed login attempts
* Identifies attacker IP addresses
* Generates alerts for suspicious activity
* Lightweight Bash implementation
* Suitable for Linux server environments

---

## Technologies Used

* **Bash scripting**
* **Linux system logs**
* **SSH authentication monitoring**

---

## How It Works

1. The script reads SSH authentication logs (such as `/var/log/auth.log`).
2. It searches for **failed SSH login attempts**.
3. It counts the number of failed attempts from each IP address.
4. If the number exceeds a defined threshold, the script generates an alert.

---

## Installation

Clone the repository:

```bash
git clone https://github.com/hassaansam/ssh-bruteforce-detection.git
cd ssh-bruteforce-detection
```

Make the script executable:

```bash
chmod +x ssh_bruteforce_detection.sh
```

---

## Usage

Run the script:

```bash
./ssh_bruteforce_detection.sh
```

The script will analyze the SSH logs and display or generate alerts for suspicious login attempts.

---

## Example Use Case

This script can be used on:

* Linux servers
* Cloud servers (AWS, Azure, DigitalOcean)
* Security monitoring environments
* Cybersecurity learning labs

---

## Future Improvements

* Email alert notifications
* Automatic IP blocking using firewall rules
* Integration with SIEM tools
* Real-time monitoring

---




