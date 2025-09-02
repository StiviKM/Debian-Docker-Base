#!/bin/bash

# Debian System Setup Script
# This script will update the system, remove GNOME, install and configure zsh with plugins,
# and install additional utilities.

set -e  # Exit immediately if any command fails

# Function to print colored output
print_status() {
    echo -e "\033[1;34m==> $1\033[0m"
}

# Function to print error messages
print_error() {
    echo -e "\033[1;31mERROR: $1\033[0m"
}

# Function to check if running as root (some operations need sudo)
check_sudo() {
    if [ "$EUID" -ne 0 ]; then
        print_error "Please run this script with sudo or as root"
        exit 1
    fi
}

# Update and upgrade system
print_status "Updating package lists..."
apt update

print_status "Upgrading system packages..."
apt upgrade -y

# Remove GNOME Desktop Environment
print_status "Removing GNOME Desktop Environment..."
apt remove --purge gnome-shell gnome-session gdm3 -y

print_status "Cleaning up unused packages..."
apt autoremove --purge -y

# Install zsh and set as default shell
print_status "Installing zsh..."
apt install zsh -y

print_status "Setting zsh as default shell..."
# For current user
chsh -s $(which zsh) $SUDO_USER

# Install git
print_status "Installing git..."
apt install git -y

# Install oh-my-zsh
print_status "Installing oh-my-zsh..."
# Run as the original user to install in their home directory
sudo -u $SUDO_USER sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)" <<< "exit"

# Install zsh plugins
print_status "Installing zsh plugins..."

# Set ZSH_CUSTOM variable
ZSH_CUSTOM="/home/$SUDO_USER/.oh-my-zsh/custom"

# Install zsh-autosuggestions
print_status "Installing zsh-autosuggestions..."
sudo -u $SUDO_USER git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions

# Install zsh-syntax-highlighting
print_status "Installing zsh-syntax-highlighting..."
sudo -u $SUDO_USER git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting

# Install fast-syntax-highlighting
print_status "Installing fast-syntax-highlighting..."
sudo -u $SUDO_USER git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git ${ZSH_CUSTOM}/plugins/fast-syntax-highlighting

# Install zsh-autocomplete
print_status "Installing zsh-autocomplete..."
sudo -u $SUDO_USER git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git $ZSH_CUSTOM/plugins/zsh-autocomplete

# Update .zshrc with plugins
print_status "Configuring .zshrc plugins..."
ZSHRC_FILE="/home/$SUDO_USER/.zshrc"

if [ -f "$ZSHRC_FILE" ]; then
    # Backup original .zshrc
    cp "$ZSHRC_FILE" "$ZSHRC_FILE.backup"
    
    # Update plugins line
    sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting fast-syntax-highlighting zsh-autocomplete)/' "$ZSHRC_FILE"
    
    print_status ".zshrc updated successfully"
else
    print_error ".zshrc file not found!"
fi

# Install SSH server (using apt instead of dnf for Debian)
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
print_status "Script completed successfully!"
echo ""
echo "Summary of changes:"
echo "✅ System updated and upgraded"
echo "✅ GNOME Desktop Environment removed"
echo "✅ zsh installed and set as default shell"
echo "✅ oh-my-zsh installed"
echo "✅ zsh plugins installed and configured"
echo "✅ OpenSSH server installed and enabled"
echo "✅ Additional utilities installed (htop, fastfetch)"
echo ""
echo "Important notes:"
echo "• zsh will be your default shell on next login"
echo "• Your original .zshrc was backed up as .zshrc.backup"
echo "• SSH server is now running and enabled on startup"
echo ""

# Reboot prompt
read -p "Do you want to reboot now? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    print_status "Rebooting system..."
    reboot
else
    print_status "Please reboot manually when ready to use the new shell: sudo reboot"
fi
