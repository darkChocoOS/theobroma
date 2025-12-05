#!/usr/bin/env bash

set -eoux pipefail

# why is this not shipped by default
dnf -y install \
  setools \
  fscrypt \
  alsa-firmware \
  google-not0-fonts-all \
  lshw \
  sbsign \
  borgbackup \
  adw-gtk3-theme \
  gvfs-nfs \
  ibus-mozc \
  ibus-unikey

# replacing cripped codecs with full versions
# uses fedora-multimedia from negativo17
dnf -y install --allowerasing --enablerepo=fedora-multimedia \
  ffmpeg \
  libavcodec \
  gstreamer1-plugins-{bad-free,bad-free-libs,good,base} \
  lame{,-libs} \
  libjxl \
  ffmpegthumbnailer

dnf -y distro-sync --from-repo=fedora-multimedia \
  libheif \
  libva \
  libva-intel-media-driver \
  intel-vpl-gpu-rt \
  intel-mediasdk \
  mesa-dri-drivers \
  mesa-filesystem \
  mesa-libEGL \
  mesa-libGL \
  mes-libgbm \
  mesa-va-drivers \
  mesa-vulkan-drivers

# upstream bug: https://bugzilla.redhat.com/show_bug.cgi?id=2332429
# swap the incorrectly installed OpenCL-ICD-Loader for ocl-icd, the expected package
dnf -y swap --from-repo=fedora \
  OpenCL-ICD-Loader ocl-icd

# ublue packages
# uses ublue-os:packages copr
dnf -y install --enablerepo copr:copr.fedorainfracloud.org:ublue-os:packages \
  uupd \
  ublue-os-luks \
  ublue-os-just \
  ublue-os-udev-rules

# uses ublue-os:flatpak-test copr
dnf -y distro-sync --from-repo=copr:copr.fedorainfracloud.org:ublue-os:flatpak-test \
  flatpak \
  flatpak-libs \
  flatpak-session-helper
  
rpm -q flatpak --qf "%{NAME} %{VENDOR}\n" | grep ublue-os

# install cosign from github
LATEST_VERSION=$(curl --retry 3 https://api.github.com/repos/sigstore/cosign/releases/latest | grep tag_name | cut -d : -f2 | tr -d "v\", ")
dnf5 install -y https://github.com/sigstore/cosign/releases/latest/download/cosign-${LATEST_VERSION}-1.x86_64.rpm

# system packages bad
dnf -y remove \
  firefox \
  fedora-bookmarks \
  fedora-chromium-config \
  firefox-langpacks \
  totem-video-thumbnailer \
  fedora-flatpak-remote \
  gnome-extensions-app \
  gnome-shell-extensions-background-logo \
  gnome-software-rpm-ostree \
  gnome-software \
  gnome-terminal-nautilus \
  yelp
