#!/usr/bin/env bash

set -eoux pipefail

dnf -y install --enablerepo secureblue \
  trivalent

dnf -y install --enablerepo copr:copr.fedorainfracloud.org:secureblue:trivalent \
  trivalent-subresource-filter

