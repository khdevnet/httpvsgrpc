#!/bin/bash

# clean
# https://learn.microsoft.com/en-us/dotnet/core/install/linux-package-mixup?pivots=os-linux-ubuntu#i-need-a-version-of-net-that-isnt-provided-by-my-linux-distribution
# apt remove 'dotnet*' 'aspnet*' 'netstandard*'
# touch /etc/apt/preferences

# "Package: dotnet* aspnet* netstandard*" >> /etc/apt/preferences
# "Pin: origin \"archive.ubuntu.com\"" >> /etc/apt/preferences
# "Pin-Priority: -10" >> /etc/apt/preferences

# Get Ubuntu version
declare repo_version=$(if command -v lsb_release &> /dev/null; then lsb_release -r -s; else grep -oP '(?<=^VERSION_ID=).+' /etc/os-release | tr -d '"'; fi)

# Download Microsoft signing key and repository
wget https://packages.microsoft.com/config/ubuntu/$repo_version/packages-microsoft-prod.deb -O packages-microsoft-prod.deb

# Install Microsoft signing key and repository
dpkg -i packages-microsoft-prod.deb

# Clean up
rm packages-microsoft-prod.deb

# Update packages
apt-get -y update
apt-get -y install $1 # $1 dotnet-sdk-7.0
