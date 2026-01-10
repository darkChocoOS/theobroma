#!/usr/bin/env bash

set -eoux pipefail

# cachyos kernel
for pkg in kernel kernel-core kernel-modules kernel-modules-core; do
  rpm --erase $pkg --nodeps
done

pushd /usr/lib/kernel/install.d
printf '%s\n' '#!/bin/sh' 'exit 0' > 05-rpmostree.install
printf '%s\n' '#!/bin/sh' 'exit 0' > 50-dracut.install
chmod +x  05-rpmostree.install 50-dracut.install
popd

dnf -y --enablerepo copr:copr.fedorainfracloud.org:bieszczaders:kernel-cachyos install \
  kernel-cachyos \
  kernel-cachyos-devel-matched

dnf -y copr enable bieszczaders/kernel-cachyos-addons
dnf -y copr disable bieszczaders/kernel-cachyos-addons
dnf -y --enablerepo copr:copr.fedorainfracloud.org:bieszczaders:kernel-cachyos-addons swap zram-generator-defaults cachyos-settings
dnf -y --enablerepo copr:copr.fedorainfracloud.org:bieszczaders:kernel-cachyos-addons install \
  scx-scheds-git \
  scx-manager


# asus tools
dnf -y install --enablerepo terra \
  asusctl \
  asusctl-rog-gui \
  supergfxctl

tee /usr/lib/bootc/kargs.d/01-HWE.toml << 'EOF'
kargs = ["amdgpu.dcdebugmask=0x10"]
EOF
