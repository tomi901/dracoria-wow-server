#!/usr/bin/env bash
#
# Shuts down services and docker DB container.
#

set -euo pipefail

sudo -v

echo "==> Shutting down services..."
sudo systemctl stop azerothcore-auth azerothcore-world

echo "==> Shutting down DB..."
docker stop ac-wow-mysql

echo "==> Done"
