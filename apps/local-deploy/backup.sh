#!/usr/bin/env bash

set -euo pipefail
# DEST=/home/acore/backups/acore
DEST=./backups
STAMP=$(date +%Y%m%d-%H%M%S)
mkdir -p "$DEST"

DUMP_OPTS="--single-transaction --quick --routines --triggers --events \
           --hex-blob --default-character-set=utf8mb4 --no-tablespaces"

mariadb-dump $DUMP_OPTS "acore_auth" \
      | zstd -19 -T0 -o "$DEST/acore_auth-${STAMP}.sql.zst"

CHARACTER_DUMP_OPTS="--ignore-table=acore_characters.logs --ignore-table=acore_characters.log_money"
mariadb-dump $DUMP_OPTS $CHARACTER_DUMP_OPTS "acore_characters" \
      | zstd -19 -T0 -o "$DEST/acore_characters-${STAMP}.sql.zst"

# We will rarely need world content backups
#mariadb-dump $DUMP_OPTS "acore_world" \
#      | zstd -19 -T0 -o "$DEST/acore_auth-${STAMP}.sql.zst"
