# 🐧 Debian Server Setup Suite

A comprehensive collection of automated scripts to transform a fresh Debian 13 (Trixie) installation into a powerful, Docker-ready server environment. This modular setup strips away unnecessary components and installs essential tools for a lean, efficient headless server.

---

## 🏗️ Script Architecture

| Script | Purpose | Order |
| :--- | :--- | :--- |
| **`Debian_Base.sh`** | Base system setup, DE removal, shell configuration | 1st |
| **`Docker_Install.sh`** | Docker Engine installation and configuration | 2nd |
| **`CasaOS_Install.sh`** | CasaOS web interface installation (Optional) | 3rd |

---

## ✨ Features

### Core System
- **Minimal Foundation**: DE-less environment for maximum performance
- **System Monitoring**: `Fastfetch` (System Info), `Htop` (Resource Monitor)
- **Remote Access**: OpenSSH Server for secure management
- **Modern Shell**: `Zsh` + `Oh My Zsh` with premium plugins

### Containerization
- **Docker Engine**: Full container runtime environment
- **Optional Web UI**: CasaOS for easy container management
- **Optimized Setup**: Pre-configured for container workloads

---

## 🚀 Installation Guide

### Prerequisites
- Fresh **Debian 13 (Trixie)** installation
- **Direct root access** (scripts require actual root user, not sudo)

### Step 1: Base System Setup

```bash
# Download and execute the main setup script
wget https://raw.githubusercontent.com/StiviKM/Debian-Docker-Base/main/Debian_Base.sh
chmod +x Debian_Base.sh
./Debian_Base.sh
```

**This will:**
- Remove GNOME desktop environment
- Install Zsh with Oh My Zsh and plugins
- Set up SSH server
- Install system monitoring tools
- Perform cleanup and optimization

### Step 2: Reboot into CLI Environment

```bash
reboot now
```

After reboot, log back in as root:
```bash
su -
```

### Step 3: Docker Installation

```bash
# Download and run Docker installation
wget https://raw.githubusercontent.com/StiviKM/Debian-Docker-Base/main/Docker_Install.sh
chmod +x Docker_Install.sh
./Docker_Install.sh
```

**This will:**
- Install Docker Engine
- Enable and start Docker service
- Verify successful installation

### Step 4: Optional - CasaOS Installation

```bash
# Download and install CasaOS web interface
wget https://raw.githubusercontent.com/StiviKM/Debian-Docker-Base/main/CasaOS_Install.sh
chmod +x CasaOS_Install.sh
./CasaOS_Install.sh
```

**This will:**
- Install CasaOS management interface
- Provide access URL and default credentials
- Integrate with existing Docker installation

---

## 🔧 Post-Installation

### Verify Installation
```bash
# Check Docker
docker --version
docker info

# Check system status
systemctl status docker
fastfetch
```

### Access Points
- **SSH**: `ssh root@your-server-ip`
- **CasaOS**: `http://your-server-ip:80` (if installed)
- **Default Credentials**: Admin (set password on first access)

---

## 📚 Official Documentation & References

### Core Technologies
- **Debian 13 (Trixie)**: [Official Documentation](https://www.debian.org/releases/trixie/)
- **Docker Engine**: [Installation Guide](https://docs.docker.com/engine/install/debian/)
- **CasaOS**: [Official Website](https://www.casaos.io/) | [GitHub Repository](https://github.com/IceWhaleTech/CasaOS)
- **Zsh**: [Official Documentation](https://www.zsh.org/)
- **Oh My Zsh**: [GitHub Repository](https://github.com/ohmyzsh/ohmyzsh)

### Security References
- **OpenSSH**: [Security Best Practices](https://www.openssh.com/security.html)
- **Docker Security**: [Official Security Guide](https://docs.docker.com/engine/security/)
- **Debian Security**: [Security Updates](https://www.debian.org/security/)

### Plugin References
- **zsh-autosuggestions**: [GitHub Repository](https://github.com/zsh-users/zsh-autosuggestions)
- **zsh-syntax-highlighting**: [GitHub Repository](https://github.com/zsh-users/zsh-syntax-highlighting)
- **fast-syntax-highlighting**: [GitHub Repository](https://github.com/zdharma-continuum/fast-syntax-highlighting)
- **zsh-autocomplete**: [GitHub Repository](https://github.com/marlonrichert/zsh-autocomplete)

### Monitoring Tools
- **htop**: [Official Documentation](https://htop.dev/)
- **Fastfetch**: [GitHub Repository](https://github.com/fastfetch-cli/fastfetch)

---

## ⚠️ Critical Disclaimer

**These scripts are provided in a beta state, "AS IS", without any warranty. Use at your own risk.**

- **ROOT USER REQUIRED**: Scripts will not work with `sudo` or privileged users
- **FRESH INSTALLS ONLY**: Designed exclusively for new Debian 13 systems
- **NO LIABILITY**: Author assumes no responsibility for data loss or system issues

**🔒 SECURITY NOTICE**: Always review scripts from the internet before execution, especially those requiring root access.

---

## 🎯 Use Cases

- **Home Servers**: Perfect for media servers, file storage, home automation
- **Development**: Clean Docker environment for development and testing
- **Learning**: Great for understanding Linux administration and containers
- **Lightweight Services**: Ideal for low-resource VPS and embedded systems

---

## 🤝 Contributing

Found an issue or have suggestions? Please open an issue on our [GitHub Repository](https://github.com/StiviKM/Debian-Docker-Base).

---
