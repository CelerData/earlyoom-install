#!/bin/bash
set -ex

ARCH=$(uname -m)

if [ "$ARCH" = "x86_64" ]; then
    PKG=earlyoom-amd64
elif [ "$ARCH" = "aarch64" ]; then
    PKG=earlyoom-aarch64
else
    echo "current arch is not supported: $ARCH"
    exit 1
fi

if [ -f /etc/os-release ]; then
    . /etc/os-release
    if [[ "$ID" == "ubuntu" ]]; then
        sudo apt-get install earlyoom
    elif [[ "$ID" == "centos" ]]; then
        sudo yum install earlyoom -y
        PKG=earlyoom-centos
    else
        echo "This is another Linux distribution: $ID"
        exit 1
    fi
else
    echo "Cannot determine the Linux distribution."
    exit 1
fi



sudo curl -o /opt/starrocks-init/earlyoom "https://raw.githubusercontent.com/CelerData/earlyoom-install/agent/pkg/$PKG"
sudo curl -o /opt/starrocks-init/jmap.sh "https://raw.githubusercontent.com/CelerData/earlyoom-install/agent/jmap.sh"
sudo mv /opt/starrocks-init/earlyoom /usr/bin/earlyoom
sudo chmod a+x /usr/bin/earlyoom
sudo sed -i 's/^EARLYOOM_ARGS=.*$/EARLYOOM_ARGS="-M 512000 -m 5 -r 600 --ignore-root-user --prefer '\''(^|\/)(agent-service)$'\'' --prefer-only"/' /etc/default/earlyoom
sudo sed -i '/^DynamicUser=/s/^/#/' /lib/systemd/system/earlyoom.service
sudo sed -i '/^TasksMax=/s/^/#/' /lib/systemd/system/earlyoom.service
sudo sed -i '/^MemoryMax=/s/^/#/' /lib/systemd/system/earlyoom.service
sudo sed -i '/\[Install\]/i ReadWritePaths=\/tmp' /lib/systemd/system/earlyoom.service
sudo chmod a+x /opt/starrocks-init/jmap.sh

sudo systemctl enable --now earlyoom