#!/bin/bash

# CasaOS Installation Script
set -e

print_status() {
    echo -e "\033[1;34m==> $1\033[0m"
}

print_error() {
    echo -e "\033[1;31mERROR: $1\033[0m"
}

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    print_error "Please run this script as root"
    exit 1
fi

print_status "Starting CasaOS installation..."

# Verify curl is installed (should be from main script)
if ! command -v curl &> /dev/null; then
    print_status "Installing curl..."
    apt update && apt install -y curl
fi

# Install CasaOS using the official method
print_status "Downloading and installing CasaOS..."
curl -fsSL https://get.casaos.io | bash

# Check if installation was successful
if [ $? -eq 0 ]; then
    print_status "CasaOS installed successfully!"
    echo ""
    echo "CasaOS should now be accessible at:"
    echo "http://$(hostname -I | awk '{print $1}'):80"
    echo ""
    echo "Default credentials:"
    echo "Username: admin"
    echo "Password: (set during first access)"
else
    print_error "CasaOS installation failed!"
    exit 1
fi