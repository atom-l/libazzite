#!/bin/bash

set -ouex pipefail

# Copy the contents of system_files/ of the git repo to /
cp -avf "/ctx/system_files"/. /

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/43/x86_64/repoview/index.html&protocol=https&redirect=1

# this installs a package from fedora repos
dnf5 install -y tmux
dnf5 install -y jq

# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

#### Example for enabling a System Unit File

systemctl enable podman.socket

# 添加自定义的justfile
cat  << EOF >> usr/share/ublue-os/justfile

import "/usr/share/ublue-os/just/999-libazzite.just"
EOF

# 修改镜像信息
IMAGE_INFO=$(cat /usr/share/ublue-os/image-info.json | jq '
    ."image-name" = "libazzite"
    | ."image-vendor" = "atom-l"
    | ."image-ref" = "ostree-image-signed:docker://ghcr.io/atom-l/libazzite"
    | ."image-tag" = "latest"
    | ."image-branch" = "main"
    | ."os-category" = "workspace"
')
echo "$IMAGE_INFO" > /usr/share/ublue-os/image-info.json
