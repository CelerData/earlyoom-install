#!/bin/bash

sudo apt-get install earlyoom

sudo curl -o /opt/starrocks-init/earlyoom "https://raw.githubusercontent.com/CelerData/earlyoom-install/main/pkg/earlyoom-amd64"
sudo mv /opt/starrocks-init/earlyoom /usr/bin/earlyoom
sudo chmod a+x /usr/bin/earlyoom
sudo sed -i 's/^EARLYOOM_ARGS=.*$/EARLYOOM_ARGS="-M 512000 -m 5 -r 600 --ignore-root-user --prefer '\''(^|\/)(starrocks_be|java|agent-service)$'\'' --prefer-only -N \/opt\/starrocks-init\/jmap.sh"/' /etc/default/earlyoom
sudo sed -i '/^DynamicUser=/s/^/#/' /lib/systemd/system/earlyoom.service
sudo sed -i '/^TasksMax=/s/^/#/' /lib/systemd/system/earlyoom.service
sudo sed -i '/^MemoryMax=/s/^/#/' /lib/systemd/system/earlyoom.service
sudo sed -i '/\[Install\]/i ReadWritePaths=\/tmp' /lib/systemd/system/earlyoom.service

sudo systemctl enable --now earlyoom