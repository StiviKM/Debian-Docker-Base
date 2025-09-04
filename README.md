# 🐧 Fresh Debian Server Setup for Docker

A sleek, automated bash script to transform a fresh Debian 13 (Trixie) installation into a lean, mean, Docker-ready machine. This script strips away the unnecessary and installs the essential tools for a powerful headless server environment.

---

## ✨ Features

| Category | Tools & Features |
| :--- | :--- |
| **System Monitoring** | `Fastfetch` (System Info), `Htop` (Resource Monitor) |
| **Modern Shell** | `Zsh` + `Oh My Zsh` with a curated selection of plugins |
| **Remote Access** | OpenSSH Server for secure remote management |
| **Containerization** | Docker Engine for container deployment |
| **Philosophy** | **DE-less** (No Graphical Desktop Environment) for minimal resource overhead |

---

## 🚀 Getting Started

### Prerequisites
- A fresh installation of **Debian 13 (Trixie)**
- **Direct root user access** (The scripts will not run with sudo privileges)

### Installation & Execution

#### Step 1: System Setup Script

1.  **Download the System Setup Script:**
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

> ⚡ The script is fully automated and requires no user interaction once started.

#### Step 2: Reboot into CLI Environment

**After the first script completes, reboot your system to enter the pure CLI environment:**
```bash
reboot now
```

**After reboot, log back in as root user:**
```bash
su -
```

#### Step 3: Docker Installation Script

1.  **Download the Docker installation script:**
    ```bash
    wget https://raw.githubusercontent.com/StiviKM/Fresh_Debian-Server_Setup/main/Docker_Install.sh
    ```

2.  **Make it executable:**
    ```bash
    chmod +x Docker_Install.sh
    ```

3.  **Execute as root user:**
    ```bash
    ./Docker_Install.sh
    ```

> 🐳 This script will install Docker Engine and enable it to start on boot.

---

## ⚠️ CRITICAL DISCLAIMER

**These scripts are provided in a beta state, "AS IS", without any warranty. Use them at your own risk.**

- **ONLY THE ROOT USER CAN EXECUTE THESE SCRIPTS.** These scripts will not work with `sudo` or users with root privileges. You must be logged in as the actual `root` user.
- They are designed exclusively for **fresh Debian 13 installations**. Running them on an existing system may cause conflicts and data loss.
- The author assumes **no responsibility** for any data loss, system instability, or other issues arising from the use of these scripts.

**⚠️ SECURITY NOTE:** Always review and understand any script from the internet before executing it, especially when requiring root access.

---

*Crafted with care for the Debian community.*
