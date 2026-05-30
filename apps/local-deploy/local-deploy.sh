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

# Modules ship their own data/ tree (SQL the DB updater applies at startup,
# resolved via <source>/modules/<mod>). `make install` doesn't place these,
# so sync each module's data/ dir into the install's source tree.
echo "==> Syncing module data trees to $DEST/source/modules"
for mod_data in "$SRC"/modules/*/data; do
  [ -d "$mod_data" ] || continue
  mod_name="$(basename "$(dirname "$mod_data")")"
  echo "    - $mod_name"
  sudo mkdir -p "$DEST/source/modules/$mod_name"
  sudo rsync -a --delete "$mod_data/" "$DEST/source/modules/$mod_name/data/"
done

echo "==> Fixing ownership"
sudo chown -R acore:acore "$DEST"

echo "==> Done"
