#!/usr/bin/env bash
#
# Shuts down services and docker DB container.
#

set -euo pipefail

sudo -v

echo "==> Starting DB..."
docker start ac-wow-mysql

echo "==> Starting services..."
sudo systemctl start azerothcore-auth azerothcore-world

echo "==> Done"
