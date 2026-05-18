#!/usr/bin/env bash
#
# Shuts down services and docker DB container.
#

set -euo pipefail

sudo -v

echo "==> Shutting down services..."
sudo systemctl stop azerothcore-world.service
sudo systemctl stop azerothcore-auth.service

echo "==> Shutting down DB..."
docker stop ac-wow-mysql

echo "==> Done"
