#!/usr/bin/env bash

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SOURCE_DIR="$REPO_ROOT/work/MeshCore"
BASE_COMMIT="0679dbeffc504d562d2f09eb072fdc223f8ffc2a"
TARGET="Tbeam_SX1276_companion_radio_ble_ps"

command -v git >/dev/null 2>&1 || { printf 'git is required\n' >&2; exit 1; }
command -v pio >/dev/null 2>&1 || { printf 'PlatformIO (pio) is required\n' >&2; exit 1; }

if [[ -e "$SOURCE_DIR" ]]; then
  printf 'Refusing to replace existing directory: %s\n' "$SOURCE_DIR" >&2
  exit 1
fi

mkdir -p "$(dirname "$SOURCE_DIR")"
git clone https://github.com/meshcore-dev/MeshCore.git "$SOURCE_DIR"
git -C "$SOURCE_DIR" checkout --detach "$BASE_COMMIT"
git -C "$SOURCE_DIR" am "$REPO_ROOT"/patches/*.patch

pio run --project-dir "$SOURCE_DIR" -e "$TARGET"
pio run --project-dir "$SOURCE_DIR" -e "$TARGET" -t mergebin

APP="$SOURCE_DIR/.pio/build/$TARGET/firmware.bin"
MERGED="$SOURCE_DIR/.pio/build/$TARGET/firmware-merged.bin"

printf '\nBuild complete.\n'
shasum -a 256 "$APP" "$MERGED"
printf '\nApplication: %s\nMerged image: %s\n' "$APP" "$MERGED"
