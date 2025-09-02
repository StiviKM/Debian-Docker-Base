# 🐧 Fresh Debian Server Setup for Docker

A sleek, automated bash script to transform a fresh Debian 13 (Trixie) installation into a lean, mean, Docker-ready machine. This script strips away the unnecessary and installs the essential tools for a powerful headless server environment.

---

## ✨ Features

| Category | Tools & Features |
| :--- | :--- |
| **System Monitoring** | `Fastfetch` (System Info), `Htop` (Resource Monitor) |
| **Modern Shell** | `Zsh` + `Oh My Zsh` with a curated selection of plugins |
| **Remote Access** | OpenSSH Server for secure remote management |
| **Philosophy** | **DE-less** (No Graphical Desktop Environment) for minimal resource overhead |

---

## 🚀 Getting Started

### Prerequisites
- A fresh installation of **Debian 13 (Trixie)**
- **Direct root user access** (The script will not run with sudo privileges)

### Installation & Execution

1.  **Download the Script:**
    ```bash
    wget https://raw.githubusercontent.com/StiviKM/Fresh_Debian-Server_Setup/main/Fresh_Debian-Server_Setup.sh
    ```

2.  **Switch to root user:**
    ```bash
    su -
    ```

3.  **Navigate to script location and make it executable:**
    ```bash
    chmod +x Fresh_Debian-Server_Setup.sh
    ```

4.  **Execute as root user:**
    ```bash
    ./Fresh_Debian-Server_Setup.sh
    ```

> ⚡ The script is fully automated and requires no user interaction once started. Sit back and watch your system transform.

---

## ⚠️ CRITICAL DISCLAIMER

**This script is provided in a beta state, "AS IS", without any warranty. Use it at your own risk.**

- **ONLY THE ROOT USER CAN EXECUTE THIS SCRIPT.** This script will not work with `sudo` or users with root privileges. You must be logged in as the actual `root` user.
- It is designed exclusively for **fresh Debian 13 installations**. Running it on an existing system may cause conflicts and data loss.
- The author assumes **no responsibility** for any data loss, system instability, or other issues arising from the use of this script.

**⚠️ SECURITY NOTE:** Always review and understand any script from the internet before executing it, especially when requiring root access.

---

*Crafted with care for the Debian community.*
