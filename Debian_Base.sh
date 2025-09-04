#!/bin/bash

# Setting a fresh installed Debian 13 as a CLI only OS, prepared for running Docker.
set -e

print_status() {
    echo -e "\033[1;34m==> $1\033[0m"
}

print_error() {
    echo -e "\033[1;31mERROR: $1\033[0m"
}

# User Detection
if [ -n "$SUDO_USER" ]; then
    ORIGINAL_USER="$SUDO_USER"
else
    # Try to get the user who logged in first
    ORIGINAL_USER=$(who | awk 'NR==1{print $1}')
    if [ -z "$ORIGINAL_USER" ]; then
        ORIGINAL_USER="test"  # Fallback to your username
    fi
fi

print_status "Detected user: $ORIGINAL_USER"

# Verify user exists and get home directory
USER_HOME=$(getent passwd "$ORIGINAL_USER" | cut -d: -f6)
if [ -z "$USER_HOME" ]; then
    print_error "User $ORIGINAL_USER not found or no home directory!"
    exit 1
fi

print_status "User home directory: $USER_HOME"

# System update and upgrade
print_status "Updating package lists..."
apt update

print_status "Upgrading system packages..."
apt upgrade -y

# Install curl (needed for Docker installation script)
print_status "Installing curl (required for Docker installation)..."
apt install -y curl

# Removing Gnome DE for a CLI only OS
print_status "Removing GNOME Desktop Environment..."
apt remove --purge gnome-shell gnome-session gdm3 -y

print_status "Cleaning up unused packages..."
apt autoremove --purge -y

# Zsh install and setting it as a default shell
print_status "Installing zsh..."
apt install zsh -y

print_status "Setting zsh as default shell for $ORIGINAL_USER..."
chsh -s $(which zsh) "$ORIGINAL_USER"

# Git install
print_status "Installing git..."
apt install git -y

# Oh-My-Zsh install with error handling
print_status "Installing oh-my-zsh..."
if su - "$ORIGINAL_USER" -c 'RUNZSH=no sh -c "$(wget -q https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"'; then
    print_status "oh-my-zsh installed successfully"
else
    print_error "oh-my-zsh installation failed, continuing with other steps..."
fi

# Zsh plugins install
ZSH_CUSTOM="$USER_HOME/.oh-my-zsh/custom"

install_plugin() {
    local plugin_name=$1
    local repo_url=$2
    local target_dir=$3
    
    print_status "Installing $plugin_name..."
    if su - "$ORIGINAL_USER" -c "git clone '$repo_url' '$target_dir' 2>/dev/null"; then
        print_status "$plugin_name installed successfully"
    else
        print_error "Failed to install $plugin_name"
    fi
}

# Create plugins directory if it doesn't exist
su - "$ORIGINAL_USER" -c "mkdir -p '$ZSH_CUSTOM/plugins'"

# Install plugins
install_plugin "zsh-autosuggestions" "https://github.com/zsh-users/zsh-autosuggestions.git" "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
install_plugin "zsh-syntax-highlighting" "https://github.com/zsh-users/zsh-syntax-highlighting.git" "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
install_plugin "fast-syntax-highlighting" "https://github.com/zdharma-continuum/fast-syntax-highlighting.git" "$ZSH_CUSTOM/plugins/fast-syntax-highlighting"
install_plugin "zsh-autocomplete" "https://github.com/marlonrichert/zsh-autocomplete.git" "$ZSH_CUSTOM/plugins/zsh-autocomplete"

# Update .zshrc with plugins
print_status "Configuring .zshrc plugins..."
ZSHRC_FILE="$USER_HOME/.zshrc"

if [ -f "$ZSHRC_FILE" ]; then
    # Backup original
    cp "$ZSHRC_FILE" "$ZSHRC_FILE.backup"
    
    # Update plugins line
    if sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting fast-syntax-highlighting zsh-autocomplete)/' "$ZSHRC_FILE"; then
        print_status ".zshrc updated successfully"
    else
        print_error "Failed to update .zshrc"
    fi
    
    # Add security fix for insecure directories warning
    print_status "Adding security fix for zsh insecure directories..."
    echo '' >> "$ZSHRC_FILE"
    echo '# Fix insecure directories warning' >> "$ZSHRC_FILE"
    echo 'if [ -n "$ZSH_VERSION" ]; then' >> "$ZSHRC_FILE"
    echo '    compaudit 2>/dev/null | xargs chmod g-w >/dev/null 2>&1' >> "$ZSHRC_FILE"
    echo 'fi' >> "$ZSHRC_FILE"
    print_status "Security fix added to .zshrc"
    
else
    print_error ".zshrc file not found! oh-my-zsh installation may have failed."
fi

# Install SSH server
print_status "Installing OpenSSH server..."
apt install -y openssh-server

print_status "Enabling SSH service..."
systemctl enable --now ssh

# Install additional utilities
print_status "Installing htop..."
apt install htop -y

print_status "Installing fastfetch..."
apt install fastfetch -y

# Final cleanup
print_status "Performing final cleanup..."
apt autoremove -y
apt clean

# Completion message
echo ""
print_status "Script completed!"
echo ""
echo "Summary:"
echo "✅ System updated"
echo "✅ GNOME removed" 
echo "✅ zsh installed and set as default"
echo "✅ git installed"
echo "✅ oh-my-zsh and plugins attempted"
echo "✅ SSH server installed"
echo "✅ Additional tools installed"
echo "✅ ZSH security fix applied"
echo ""
echo "Next steps:"
echo "1. Reboot the system to enter CLI-only environment"
echo "2. Log back in as root user"
echo "3. Download and run the Docker installation script:"
echo "   wget https://raw.githubusercontent.com/StiviKM/Fresh_Debian-Server_Setup/main/Docker_Install.sh"
echo "   chmod +x Docker_Install.sh"
echo "   ./Docker_Install.sh"
echo ""

read -p "Do you want to reboot now? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    print_status "Rebooting system..."
    sudo reboot
else
    print_status "Please log out and back in to start using zsh."
fi
