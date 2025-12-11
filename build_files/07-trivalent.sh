# Copyright 2025 Amy
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#!/usr/bin/env bash

set -eoux pipefail

dnf -y install --enablerepo secureblue \
  trivalent

dnf -y install --enablerepo copr:copr.fedorainfracloud.org:secureblue:trivalent \
  trivalent-subresource-filter

# Install Trivalent SELinux policy
echo "Installing secureblue Trivalent selinux policy"
echo "Install 'selinux-policy-devel' build package & it's dependencies"
dnf5 -y install policycoreutils-devel
echo "Downloading secureblue Trivalent selinux policy"
TRIVALENT_POLICY_URL="https://raw.githubusercontent.com/secureblue/secureblue/refs/heads/live/files/scripts/selinux/trivalent"
SELINUX_SCRIPT_URL="https://raw.githubusercontent.com/secureblue/secureblue/refs/heads/live/files/scripts/installselinuxpolicies.sh"
curl -fLs --create-dirs -O "${TRIVALENT_POLICY_URL}/trivalent.fc" --output-dir ./selinux/trivalent
curl -fLs --create-dirs -O "${TRIVALENT_POLICY_URL}/trivalent.if" --output-dir ./selinux/trivalent
curl -fLs --create-dirs -O "${TRIVALENT_POLICY_URL}/trivalent.te" --output-dir ./selinux/trivalent
curl -fLs --create-dirs -O "${SELINUX_SCRIPT_URL}" --output-dir "${PWD}"
echo "Patching selinux script to only do Trivalent-related changes"
sed -i 's/^policy_modules=.*/policy_modules=(trivalent)/' "${PWD}/installselinuxpolicies.sh"
sed -i '/\${cil_policy_modules\[\@\]}/d' "${PWD}/installselinuxpolicies.sh"
echo "Executing trivalent.sh script"
bash "${PWD}/installselinuxpolicies.sh"
echo "Cleaning up build package 'selinux-policy-devel' & it's dependencies"
dnf5 -y remove selinux-policy-devel

echo "Assure that network sandbox is always disabled by default (to ensure that login data remains)"
echo "https://github.com/fedora-silverblue/issue-tracker/issues/603"
echo -e '\nCHROMIUM_FLAGS+=" --disable-features=NetworkServiceSandbox"' >> /etc/trivalent/trivalent.conf

echo "Enable middle-click scrolling by default"
sed -i '/CHROMIUM_FLAGS+=" --enable-features=\$FEATURES"/d' /etc/trivalent/trivalent.conf
echo -e '\nFEATURES+=",MiddleClickAutoscroll"\nCHROMIUM_FLAGS+=" --enable-features=$FEATURES"' >> /etc/trivalent/trivalent.conf


# Apply SELinux type "user_home_t" on external drives to allow access from Trivalent
media_path="/run/media/$USER/"
selabel="user_home_t"
supported_fs=("ext2" "ext3" "ext4" "jfs" "xfs" "btrfs") # ref: https://wiki.gentoo.org/wiki/SELinux/FAQ#Can_I_use_SELinux_with_any_file_system.3F

if [ -z "$( ls -A "$media_path" 2>&- )" ]; then
    echo "You don't have any drives mounted in \"$media_path\", aborting."
    exit 0
fi
echo "Warning: This will label your drives mounted on \"$media_path\" such that they are treated as an extension to your home directory. (You can select which ones to label)"
echo 'If you do not want Trivalent to have access to these drives, do not proceed.'
read -rp 'Are you sure you want to do this? [y/N] ' warning_proceed
if ! [[ "$warning_proceed" == [Yy]* ]]; then
    echo 'Aborting.'
    exit 0
fi

for dir in "$media_path"*/
do
    echo
    if [[ "$dir" =~ "'" ]]; then
        echo "WARNING: Single quotes in drive labels are forbidden to avoid command execution, skipping drive \"$dir\"..."
        continue
    fi
    if [[ "$(stat -c '%U' "$dir")" != "$USER" ]]; then
        echo "Drive root folder is not owned by you, skipping drive \"$dir\"..."
        continue
    fi
    detected_fs="$(df -T "$dir" | awk '{print $2}' | sed -n 2p)"
    if ! printf "%s\n" "${supported_fs[@]}" | grep -Fxq "$detected_fs"; then
        echo "SELinux support is unknown for filesystem $detected_fs, skipping drive \"$dir\"..."
        continue
    fi
    read -rp "Do you want to label \"$dir\"? [y/N] " proceed
    if ! [[ "$proceed" == [Yy]* ]]; then
        echo 'Skipping...'
        continue
    fi
    echo "Labeling drive mounted on \"$dir\" with $selabel"
    dir=${dir%*/} # remove trailing slash
    if ! run0 sh -c "semanage fcontext -a -t $selabel '$dir(/.*)?' && restorecon -r '$dir'"; then
        echo 'Execution failed, aborting.'
        exit 1
    fi
done

echo -e '\nDone.'


touch /etc/ld.so.preload
