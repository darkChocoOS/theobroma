#!/usr/bin/env bash

set -eoux pipefail

# needed for managing extra repositories
dnf -y install dnf5-plugins

# cachyos kernel
dnf -y copr enable bieszczaders/kernel-cachyos
dnf -y copr disable bieszczaders/kernel-cachyos

# secureblue selinux policy
dnf -y copr enable secureblue/selinux-policy
dnf -y copr disable secureblue/selinux-policy

# negativo17 fedora-multimedia
dnf -y config-manager addrepo --from-repofile=https://negativo17.org/repos/fedora-multimedia.repo
dnf -y config-manager setopt fedora-multimedia.enabled=0

# trivalent
dnf -y config-manager addrepo --from-repofile=https://repo.secureblue.dev/secureblue.repo
dnf -y config-manager setopt secureblue.enabled=0

# trivalent subresource filter
dnf -y copr enable secureblue/trivalent
dnf -y copr disable secureblue/trivalent

# terra
dnf -y install --nogpgcheck --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' terra-release
dnf -y config-manager setopt terra.enabled=0

# ublue packages
# TODO: move away from these once possible
dnf -y copr enable ublue-os/packages
dnf -y copr disable ublue-os/packages

# ublue flatpak
dnf -y copr enable ublue-os/flatpak-test
dnf -y copr disable ublue-os/flatpak-test
