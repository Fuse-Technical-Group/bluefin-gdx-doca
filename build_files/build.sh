#!/bin/bash

set -ouex pipefail

# Customize OS name for GRUB boot menu
sed -i 's/^PRETTY_NAME=.*/PRETTY_NAME="Bluefin-GDX DOCA"/' /usr/lib/os-release
# Also update /etc/os-release if it exists as a regular file
if [ -f /etc/os-release ] && [ ! -L /etc/os-release ]; then
    sed -i 's/^PRETTY_NAME=.*/PRETTY_NAME="Bluefin-GDX DOCA"/' /etc/os-release
fi
### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

# this installs a package from fedora repos
#dnf5 install -y tmux 

# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

#### Example for enabling a System Unit File

systemctl enable podman.socket

# Enable VPN services
systemctl enable tailscaled.service

# Create NVIDIA DOCA repository configuration for RHEL 10
cat > /etc/yum.repos.d/doca.repo << 'EOF'
[doca]
name=NVIDIA DOCA for RHEL 10
baseurl=https://linux.mellanox.com/public/repo/doca/latest/rhel10.0/x86_64/
enabled=1
gpgcheck=0
EOF

rpm-ostree install \
    doca-all \
    doca-roce \
    rivermax \
    rivermax-utils \
    mft \
    rdma-core \
    libibverbs \
    librdmacm \
    perftest