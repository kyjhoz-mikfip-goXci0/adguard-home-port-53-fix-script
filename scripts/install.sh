#!/bin/bash

# Function to print date and time
print_date_time() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') $1"
}

# Check if port 53 is in use
print_date_time "Checking if port 53 is in use:"
sudo lsof -i :53

# Check if systemd-resolved is using port 53
if sudo lsof -i :53 | grep -q 'systemd-resolve'; then
    print_date_time "systemd-resolved is using port 53."

    # Check for and create the directory /etc/systemd/resolved.conf.d
    if [ ! -d "/etc/systemd/resolved.conf.d" ]; then
        print_date_time "Directory /etc/systemd/resolved.conf.d does not exist. Creating now:"
        sudo mkdir /etc/systemd/resolved.conf.d
    fi

    # Check for and create the file /etc/systemd/resolved.conf.d/adguardhome.conf
    if [ ! -f "/etc/systemd/resolved.conf.d/adguardhome.conf" ]; then
        print_date_time "File /etc/systemd/resolved.conf.d/adguardhome.conf does not exist. Creating now:"
        echo -e "[Resolve]\nDNS=127.0.0.1\nDNSStubListener=no" | sudo tee /etc/systemd/resolved.conf.d/adguardhome.conf
    fi
fi

# Activate another resolve.conf file
print_date_time "Activating another resolve.conf file:"
sudo mv /etc/resolv.conf /etc/resolv.conf.backup
sudo ln -s /run/systemd/resolve/resolv.conf /etc/resolv.conf

# Restart the DNSStubListener
print_date_time "Restarting the DNSStubListener:"
sudo systemctl reload-or-restart systemd-resolved

# Perform a final check showing whether systemd-resolved is still using port 53
print_date_time "Performing a final check to see if systemd-resolved is still using port 53:"
sudo lsof -i :53
