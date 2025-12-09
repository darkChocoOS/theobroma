#!/usr/bin/env bash

set -eoux pipefail

dnf -y install \
  buildah \
  distrobox \
  flatpak-builder \
  foundry \
  gcc-c++ \
  git \
  libvirt \
  libvirt-daemon-kvm \
  libvirt-nss

dnf -y install --enablerepo terra \
  ghostty

dnf -y install --enablerepo copr:copr.fedorainfracloud.org:ublue-os:packages \
  ublue-brew \
  ublue-os-libvirt-workarounds
