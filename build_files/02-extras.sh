#!/usr/bin/env bash

set -eoux pipefail

cp -avf "/ctx/files"/. /

# why is this not shipped by default
dnf -y install \
  brightnessctl \
  cava \
  chezmoi \
  distrobox \
  fastfetch \
  flatpak \
  flatpak-builder \
  foot \
  foundry \
  fpaste \
  fzf \
  git \
  glycin-thumbnailer \
  hyfetch \
  input-remapper \
  just \
  libvirt \
  libvirt-daemon-kvm \
  libvirt-nss \
  openssh-askpass \
  orca \
  pipewire \
  steam-devices \
  webp-pixbuf-loader \
  wireplumber \
  wl-clipboard \
  wlsunset

dnf -y install --enablerepo copr:copr.fedorainfracloud.org:ublue-os:packages \
  ublue-os-libvirt-workarounds

dnf install -y \
  default-fonts-core-emoji \
  google-noto-color-emoji-fonts \
  google-noto-emoji-fonts \
  google-noto-fonts-all \
  glibc-all-langpacks \
  default-fonts

# install codecs from negativo so they aren't crippled
dnf -y install --enablerepo=fedora-multimedia \
  -x PackageKit* \
  ffmpeg libavcodec @multimedia gstreamer1-plugins-{bad-free,bad-free-libs,good,base} lame{,-libs} libjxl ffmpegthumbnailer

fc-cache --force --really-force --system-only --verbose
