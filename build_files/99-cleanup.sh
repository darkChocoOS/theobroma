#!/usr/bin/env bash

set -eoux pipefail

HOME_URL=https://github.com/darkChocoOS/theobroma
echo "darkChocoOS" | tee "/etc/hostname"

# OS Release File
sed -i -f - /usr/lib/os-release << EOF
s|^NAME=.*|NAME=\"theobroma\"|
s|^PRETTY_NAME=.*|PRETTY_NAME=\"theobroma\"|
s|^VERSION_CODENAME=.*|VERSION_CODENAME=\"Juno\"|
s|^VARIANT_ID=.*|VARIANT_ID=""|
s|^HOME_URL=.*|HOME_URL=\"${HOME_URL}\"|
s|^BUG_REPORT_URL=.*|BUG_REPORT_URL=\"${HOME_URL}/issues\"|
s|^SUPPORT_URL=.*|SUPPORT_URL=\"${HOME_URL}/issues\"|
s|^CPE_NAME=\".*\"|CPE_NAME=\"cpe:/o:darkChocoOS:theobroma\"|
s|^DOCUMENTATION_URL=.*|DOCUMENTATION_URL=\"${HOME_URL}\"|
s|^DEFAULT_HOSTNAME=.*|DEFAULT_HOSTNAME="theobroma"|

/^REDHAT_BUGZILLA_PRODUCT=/d
/^REDHAT_BUGZILLA_PRODUCT_VERSION=/d
/^REDHAT_SUPPORT_PRODUCT=/d
/^REDHAT_SUPPORT_PRODUCT_VERSION=/d
EOF

# disable uupd checking for distrobox updates
sed -i 's|uupd|$ --disable-module-distrobox' /usr/lib/systemd/uupd.service

# enable system daemon for supergfxctl
systemctl enable supergfxd.service

# enable update timers for brew and system
systemctl enable brew-setup.service
systemctl enable uupd.timer

# add flathub repo for eventual application
mkdir -p /etc/flatpak/remotes.d/
curl --retry 3 -Lo /etc/flatpak/remotes.d/flathub.flatpakrepo https://dl.flathub.org/repo/flathub.flatpakrepo

# fuck off fedora flatpaks
rm -rf /usr/lib/systemd/system/flatpak-add-fedora-repos.service
systemctl enable flatpak-add-flathub-repos.service

# enable flatpak preinstall service
systemctl enable flatpak-preinstall.service


KERNEL_VERSION="$(find "/usr/lib/modules" -maxdepth 1 -type d ! -path "/usr/lib/modules" -exec basename '{}' ';' | sort | tail -n 1)"
export DRACUT_NO_XATTR=1
dracut --no-hostonly --kver "$KERNEL_VERSION" --reproducible --zstd -v --add ostree -f "/usr/lib/modules/$KERNEL_VERSION/initramfs.img"
chmod 0600 "/usr/lib/modules/${KERNEL_VERSION}/initramfs.img"
