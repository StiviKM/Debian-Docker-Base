#!/bin/bash

# Debian System Setup Script - Fixed version for direct root execution
set -e

print_status() {
    echo -e "\033[1;34m==> $1\033[0m"
}

print_error() {
    echo -e "\033[1;31mERROR: $1\033[0m"
}

# Get the original username (if available)
ORIGINAL_USER=$(logname 2>/dev/null || echo "test")

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
chsh -s $(which zsh) $ORIGINAL_USER

# Install git
print_status "Installing git..."
apt install git -y

# Install oh-my-zsh as the regular user
print_status "Installing oh-my-zsh..."
su - $ORIGINAL_USER -c 'sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)" <<< "exit"'

# Install zsh plugins
print_status "Installing zsh plugins..."

ZSH_CUSTOM="/home/$ORIGINAL_USER/.oh-my-zsh/custom"

# Install plugins as the regular user
print_status "Installing zsh-autosuggestions..."
su - $ORIGINAL_USER -c "git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions"

print_status "Installing zsh-syntax-highlighting..."
su - $ORIGINAL_USER -c "git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting"

print_status "Installing fast-syntax-highlighting..."
su - $ORIGINAL_USER -c "git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git $ZSH_CUSTOM/plugins/fast-syntax-highlighting"

print_status "Installing zsh-autocomplete..."
su - $ORIGINAL_USER -c "git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git $ZSH_CUSTOM/plugins/zsh-autocomplete"

# Update .zshrc with plugins
print_status "Configuring .zshrc plugins..."
ZSHRC_FILE="/home/$ORIGINAL_USER/.zshrc"

if [ -f "$ZSHRC_FILE" ]; then
    cp "$ZSHRC_FILE" "$ZSHRC_FILE.backup"
    sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting fast-syntax-highlighting zsh-autocomplete)/' "$ZSHRC_FILE"
    print_status ".zshrc updated successfully"
else
    print_error ".zshrc file not found!"
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
print_status "Script completed successfully!"
echo ""
echo "To use your new zsh shell, either:"
echo "1. Log out and log back in"
echo "2. Run: su - $ORIGINAL_USER"
echo "3. Or reboot the system"
echo ""

read -p "Do you want to reboot now? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    print_status "Rebooting system..."
    sudo reboot
else
    print_status "Please log out and back in to use zsh, or reboot later."
fi
