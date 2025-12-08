#!/usr/bin/env bash
# making fedora-bootc not completely horrible LOL

set -eoux pipefail

# install wifi card firmware
dnf -y install \
    NetworkManager-wifi \
    atheros-firmware \
    brcmfmac-firmware \
    iwlegacy-firmware \
    iwlwifi-dvm-firmware \
    iwlwifi-mvm-firmware \
    mt7xxx-firmware \
    nxpwireless-firmware \
    realtek-firmware \
    tiwilink-firmware \

# This package adds "[systemd] Failed Units: *" to the bashrc startup
dnf -y remove console-login-helper-messages \
    chrony

# install alsa firmware
dnf install -y \
  alsa-firmware \
  alsa-sof-firmware \
  alsa-tools-firmware \
  intel-audio-firmware

# install basic missing packages
dnf -y install \
  audit \
  audispd-plugins \
  cifs-utils \
  fedora-logos \
  firewalld \
  fuse \
  fuse-common \
  fwupd \
	gvfs-mtp \
  gvfs-smb \
  ifuse \
	jmtpfs \
  libimobiledevice \
  man-db \
  plymouth \
  plymouth-system-theme \
  rclone \
  steam-devices \
  systemd-container \
  tuned \
  tuned-ppd \
  unzip \
  uxplay \
  whois

# fix bootc updates and rpm-ostree
sed -i 's|^ExecStart=.*|ExecStart=/usr/bin/bootc update --quiet|' /usr/lib/systemd/system/bootc-fetch-apply-updates.service
sed -i 's|^OnUnitInactiveSec=.*|OnUnitInactiveSec=7d\nPersistent=true|' /usr/lib/systemd/system/bootc-fetch-apply-updates.timer
sed -i 's|#AutomaticUpdatePolicy.*|AutomaticUpdatePolicy=stage|' /etc/rpm-ostreed.conf
sed -i 's|#LockLayering.*|LockLayering=true|' /etc/rpm-ostreed.conf

# add zram
tee /usr/lib/systemd/zram-generator.conf <<'EOF'
[zram0]
zram-size = min(ram, 8192)
EOF

# enable resolved by default
tee /usr/lib/systemd/system-preset/91-resolved-default.preset <<'EOF'
enable systemd-resolved.service
EOF
tee /usr/lib/tmpfiles.d/resolved-default.conf <<'EOF'
L /etc/resolv.conf - - - - ../run/systemd/resolve/stub-resolv.conf
EOF

# upstream bug: https://bugzilla.redhat.com/show_bug.cgi?id=2332429
# swap the incorrectly installed OpenCL-ICD-Loader for ocl-icd, the expected package
dnf -y swap --from-repo=fedora \
  OpenCL-ICD-Loader ocl-icd
  
# necessary ublue packages
dnf -y install --enablerepo copr:copr.fedorainfracloud.org:ublue-os:packages \
  uupd \
  ublue-os-just \
  ublue-os-luks \
  ublue-os-udev-rules

dnf5 config-manager setopt copr:copr.fedorainfracloud.org:ublue-os:flatpak-test.priority=90
# uses ublue-os:flatpak-test copr
dnf -y distro-sync --from-repo=copr:copr.fedorainfracloud.org:ublue-os:flatpak-test \
  flatpak \
  flatpak-session-helper
dnf -y install --enablerepo copr:copr.fedorainfracloud.org:ublue-os:flatpak-test \
  flatpak-libs

rpm -q flatpak --qf "%{NAME} %{VENDOR}\n" | grep ublue-os

# install cosign from github
LATEST_VERSION=$(curl --retry 3 https://api.github.com/repos/sigstore/cosign/releases/latest | grep tag_name | cut -d : -f2 | tr -d "v\", ")
dnf5 install -y https://github.com/sigstore/cosign/releases/latest/download/cosign-${LATEST_VERSION}-1.x86_64.rpm
