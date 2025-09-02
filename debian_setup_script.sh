#!/bin/bash

# Debian System Setup Script - Robust version for direct root execution
set -e

print_status() {
    echo -e "\033[1;34m==> $1\033[0m"
}

print_error() {
    echo -e "\033[1;31mERROR: $1\033[0m"
}

# Detect the original user more reliably
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

print_status "Setting zsh as default shell for $ORIGINAL_USER..."
chsh -s $(which zsh) "$ORIGINAL_USER"

# Install git
print_status "Installing git..."
apt install git -y

# Install oh-my-zsh as the regular user - with better error handling
print_status "Installing oh-my-zsh..."
if su - "$ORIGINAL_USER" -c 'RUNZSH=no sh -c "$(wget -q https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"'; then
    print_status "oh-my-zsh installed successfully"
else
    print_error "oh-my-zsh installation failed, continuing with other steps..."
fi

# Install zsh plugins with better error handling
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
echo ""
echo "Next steps:"
echo "1. Log out and log back in to use zsh"
echo "2. Or run: su - $ORIGINAL_USER"
echo "3. Check if oh-my-zsh installed correctly in $USER_HOME/.oh-my-zsh"
echo ""

read -p "Do you want to reboot now? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    print_status "Rebooting system..."
    sudo reboot
else
    print_status "Please log out and back in to start using zsh."
fi
