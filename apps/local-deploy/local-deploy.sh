#!/usr/bin/env bash
#
# Build & deploy AzerothCore to the `acore` user's install dir.
# Run as your normal user. Sudo will prompt once at the start.
#
# Layout:
#   source     -> $(dirname $0)                       (owned by you)
#   install    -> /home/acore/server                  (owned by acore)
#   services   -> azerothcore-auth, azerothcore-world (systemd, run as acore)

set -euo pipefail

SRC="$( cd "$( dirname $0 )/../.." && pwd )"
DEST="/home/acore/server"
BUILD="$SRC/build"
JOBS="$(nproc --all)"

sudo -v

echo "==> Building (-j$JOBS)"
make -C "$BUILD" -j"$JOBS"

echo "==> Installing to $DEST"
sudo make -C "$BUILD" install

echo "==> Syncing source data tree to $DEST/source"
sudo rsync -a --delete "$SRC/data/" "$DEST/source/data/"

echo "==> Fixing ownership"
sudo chown -R acore:acore "$DEST"

echo "==> Done"
