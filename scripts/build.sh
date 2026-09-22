#!/usr/bin/env bash

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SOURCE_DIR="$REPO_ROOT/work/MeshCore"
BASE_COMMIT="0679dbeffc504d562d2f09eb072fdc223f8ffc2a"
TARGET="Tbeam_SX1276_companion_radio_ble_ps"
EXPECTED_TREE="6649a527e348645a32b41905d181dc1e62794c9f"

command -v git >/dev/null 2>&1 || { printf 'git is required\n' >&2; exit 1; }
command -v pio >/dev/null 2>&1 || { printf 'PlatformIO (pio) is required\n' >&2; exit 1; }
command -v shasum >/dev/null 2>&1 || { printf 'shasum is required\n' >&2; exit 1; }

(cd "$REPO_ROOT/patches" && shasum -a 256 -c SHA256SUMS.txt)

if [[ -e "$SOURCE_DIR" ]]; then
  printf 'Refusing to replace existing directory: %s\n' "$SOURCE_DIR" >&2
  exit 1
fi

mkdir -p "$(dirname "$SOURCE_DIR")"
git clone https://github.com/meshcore-dev/MeshCore.git "$SOURCE_DIR"
git -C "$SOURCE_DIR" checkout --detach "$BASE_COMMIT"
git -C "$SOURCE_DIR" -c user.name='Hybrid build' -c user.email='build@example.invalid' am "$REPO_ROOT"/patches/*.patch
ACTUAL_TREE="$(git -C "$SOURCE_DIR" rev-parse 'HEAD^{tree}')"
if [[ "$ACTUAL_TREE" != "$EXPECTED_TREE" ]]; then
  printf 'Source tree mismatch: %s (expected %s)\n' "$ACTUAL_TREE" "$EXPECTED_TREE" >&2
  exit 1
fi

pio run --project-dir "$SOURCE_DIR" -e "$TARGET"

APP="$SOURCE_DIR/.pio/build/$TARGET/firmware.bin"

printf '\nBuild complete.\n'
shasum -a 256 "$APP"
printf '\nApplication: %s\nFlash offset: 0x10000 only; verify board/layout and back up first.\n' "$APP"
