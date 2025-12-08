#!/usr/bin/env bash

set -eoux pipefail

# why is this not shipped by default
dnf -y install \
  setools \
  fscrypt \
  google-noto-fonts-all \
  lshw \
  sbsign \
  borgbackup \
  gvfs-nfs \
  ibus-mozc \
  ibus-unikey \
  apr \
  apr-util \
  brightnessctl \
  ddcutil \
  fastfetch \
  gamescope \
  glycin-thumbnailer \
  gnome-keyring \
  gnome-keyring-pam \
  input-remapper \
  orca \
  nautilus \
  gvfs-nfs \
  glibc-all-langpacks \
  wl-clipboard \
  xdg-desktop-portal-gnome

# install drivers from negativo so they aren't crippled
dnf5 config-manager setopt fedora-multimedia.priority=0
dnf -y distro-sync --from-repo=fedora-multimedia \
  libheif \
  libva \
  intel-mediasdk \
  mesa-dri-drivers \
  mesa-filesystem \
  mesa-libEGL \
  mesa-libGL \
  mesa-libgbm \
  mesa-va-drivers \
  mesa-vulkan-drivers

dnf -y install --enablerepo fedora-multimedia \
  intel-gmmlib \
  libva-intel-media-driver

# install codecs from negativo too
dnf -y install --enablerepo fedora-multimedia \
  ffmpeg \
  libavcodec \
  gstreamer1-plugins-{bad-free,bad-free-libs,good,base} \
  lame{,-libs} \
  libcamera \
  libcamera-gstreamer \
  libcamera-ipa \
  libheif \
  libcamera-tools \
  libcamera-v4l2 \
  libfdk-aac \
  libimobiledevice-utils \
  libjxl \
  ffmpegthumbnailer

dnf5 config-manager setopt fedora-multimedia.priority=99
