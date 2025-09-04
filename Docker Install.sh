#!/bin/bash

# Docker Installation Script for Root
echo "Starting Docker installation as root..."

# Download the Docker installation script
echo "Downloading Docker installation script..."
curl -fsSL https://get.docker.com -o get-docker.sh

# Verify download was successful
if [ ! -f "get-docker.sh" ]; then
    echo "Error: Failed to download Docker installation script."
    exit 1
fi

# Make the script executable
chmod +x get-docker.sh

# Run the Docker installation script
echo "Installing Docker..."
sh ./get-docker.sh

# Enable and start Docker service
echo "Enabling and starting Docker service..."
systemctl enable docker
systemctl start docker

# Verify installation
echo "Verifying Docker installation..."
docker --version
if [ $? -eq 0 ]; then
    echo "Docker installed successfully!"
else
    echo "Docker installation may have failed."
fi

# Clean up the installation script
echo "Cleaning up..."
rm -f get-docker.sh

echo "Docker installation process completed."