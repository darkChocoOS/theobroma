#!/usr/bin/env bash

set -eoux pipefail

dnf -y install \
  buildah \
  distrobox \
  libvirt \
  libvirt-daemon-kvm \
  libvirt-nss \
  virt-install \
  virt-manager

dnf -y install --enablerepo terra-release \
  ghostty

dnf -y install --enablerepo copr:copr.fedorainfracloud.org:ublue-os:packages \
  ublue-brew \
  ublue-os-libvirt-workarounds

dnf -y remove \
  toolbx
