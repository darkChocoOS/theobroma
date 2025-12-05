#!/usr/bin/env bash

set -eoux pipefail

# cachyos kernel
dnf -y copr enable bieszczaders/kernel-cachyos
dnf -y copr disable bieszczaders/kernel-cachyos

# secureblue selinux policy
dnf copr enable secureblue/selinux-policy
dnf copr disable secureblue/selinux-policy

# negativo17 fedora-multimedia
dnf config-manager addrepo --from-repofile=https://negativo17.org/repos/fedora-multimedia.repo
dnf config-manager setopt fedora-multimedia.enabled=0

# negativo17 fedora-nvidia
dnf config-manager addrepo --from-repofile=https://negativo17.org/repos/fedora-nvidia.repo
dnf config-manager setopt fedora-nvidia.enabled=0

# nvidia container toolkit
dnf config-manager addrepo --from-repofile=https://nvidia.github.io/libnvidia-container/stable/rpm/nvidia-container-toolkit.repo
dnf config-manager setopt nvidia-container-toolkit.enabled=0
dnf config-manager setopt nvidia-container-toolkit.gpgcheck=1

# trivalent
dnf config-manager addrepo --from-repofile=https://repo.secureblue.dev/secureblue.repo
dnf config-manager setopt secureblue.enabled=0

# terra
dnf -y install --nogpgcheck --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' terra-release
dnf config-manager setopt terra-release.enabled=0

# ublue packages
# TODO: move away from these once possible
dnf copr enable ublue-os/packages
dnf copr disable ublue-os/packages

# ublue flatpak
dnf -y copr enable ublue-os/flatpak-test
dnf -y copr disable ublue-os/flatpak-test

#  # proton (fuck that rpm tbh)
#  tee /etc/yum.repos.d/protonvpn-stable.repo << 'EOF'
#  #
#  # ProtonVPN stable release
#  #
#  [protonvpn-fedora-stable]
#  name = ProtonVPN Fedora Stable repository
#  baseurl = https://repo.protonvpn.com/fedora-$releasever-stable
#  enabled = 0
#  gpgcheck = 1
#  repo_gpgcheck=0
#  skip_if_unavailable=true
#  gpgkey = https://repo.protonvpn.com/fedora-$releasever-stable/public_key.asc
#  EOF
