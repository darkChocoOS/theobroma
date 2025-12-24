#/usr/bin/env bash

set -eoux pipefail

dnf -y install \
  adw-gtk3-theme \
  gdm \
  gnome-bluetooth \
  gnome-color-manager \
  gnome-disk-utility \
  gnome-initial-setup \
  gnome-keyring \
  gnome-keyring-pam \
  gnome-remote-desktop \
  gnome-session \
  gnome-settings-daemon \
  gnome-shell \
  gnome-user-docs \
  gvfs-fuse \
  gvfs-goa \
  gvfs-gphoto2 \
  nautilus \
  sane-backends-drivers-scanners \
  wget \
  xdg-desktop-portal-gnome \
  xdg-desktop-portal-gtk \
  xdg-user-dirs \
  xdg-user-dirs-gtk

