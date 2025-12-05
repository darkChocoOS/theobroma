#!/usr/bin/env bash

set -eoux pipefail

dnf -y install --enablerepo secureblue \
  trivalent \
  trivalent-subresource-filter

dnf -y install --enablerepo copr:copr.fedorainfracloud.org:secureblue:selinux-policy \
  selinux-policy
