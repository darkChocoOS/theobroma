#/usr/bin/env bash

set -eoux pipefail

dnf -y install \
  adw-gtk3-theme \
  NetworkManager-adsl \
  gdm \
  gnome-bluetooth \
  gnome-color-manager \
  gnome-disk-utility \
  gnome-initial-setup \
  gnome-remote-desktop \
  gnome-session \
  gnome-settings-daemon \
  gnome-shell \
  gnome-user-docs \
  gvfs-fuse \
  gvfs-goa \
  gvfs-ghoto2 \
  libsane-hpaio \
  sane-backends-drivers-scanners \
  wget \
  xdg-user-dirs-gtk

