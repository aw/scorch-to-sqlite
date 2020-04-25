#!/bin/sh
#
# Script to convert a Scorch DB to SQLite
#   Scorch: https://github.com/trapexit/scorch
#
# Usage: ./scorch-to-sqlite.sh /path/to/scorch.db
#  Outputs /path/to/scorch.db.sqlite
#
# The MIT License (MIT)
# https://github.com/aw/scorch-to-sqlite
#
# Copyright (c) 2020 Alexander Williams, Unscramble <license@unscramble.jp>

set -u
set -e

scorch_csv="$(mktemp)"
scorch_db="$1"
scorch_sql="${scorch_db}.sqlite"

cleanup() {
  rm -f "$scorch_csv"
}

trap cleanup EXIT

echo 'file,hash,size,mode,mtime,inode' > "$scorch_csv"

echo "Decompressing DB: $scorch_db"
gzip -d -k -c "$scorch_db" >> "$scorch_csv"

echo "Importing DB into SQLite: $scorch_sql"
sqlite3 -csv "$scorch_sql" ".import $scorch_csv scorch"
