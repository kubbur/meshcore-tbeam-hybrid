# Flashing

Flashing firmware can leave a device unbootable if power or USB is interrupted. Confirm the exact board, radio and flash layout before writing. Back up the complete device first and keep that backup private.

## Build outputs

After `bash scripts/build.sh`, the relevant files are under:

```text
work/MeshCore/.pio/build/Tbeam_SX1276_companion_radio_ble_ps/
```

- `firmware.bin`: application image for offset `0x10000`

The release download is named `meshcore-tbeam-hybrid-v1.17.1-hybrid-ps3-rc2-app-0x10000.bin`. Verify it against the release's `SHA256SUMS.txt` before use. The build script now produces only the application by default; no merged or full-flash image is published.

## Preserve identity and settings

The tested partition layout stores NVS at `0x9000` and SPIFFS at `0x3d0000`, with `app0` at `0x10000` (capacity `0x1e0000`), `app1` at `0x1f0000` and boot selection at `0xe000`. Verify the installed partition map and active boot selection match the intended `app0` update before writing; chip/flash identification alone does not establish this. An application-only write at `0x10000` does not target user-data partitions. Firmware may still write settings during normal operation, so this is not a byte-for-byte preservation or restore guarantee. Do not erase flash for an ordinary update.

Before any write, use a recent esptool release to identify the ESP32 and read a complete 4 MB backup. Store it securely; it can contain private keys and credentials.

## Application-only update

Set `PORT` to the exact serial device after verifying it:

```bash
PORT=/dev/cu.your-verified-device
python3 -m esptool --chip esp32 --port "$PORT" --baud 115200 chip-id
python3 -m esptool --chip esp32 --port "$PORT" --baud 115200 flash-id
python3 -m esptool --chip esp32 --port "$PORT" --baud 115200 write-flash \
  --flash-mode dio --flash-freq 40m --flash-size 4MB \
  0x10000 work/MeshCore/.pio/build/Tbeam_SX1276_companion_radio_ble_ps/firmware.bin
```

These commands run on the attached host and the final command resets and writes the device. They use the locally built image, not a download. For a release download, replace only the final image path with the verified downloaded application file. Do not change the `0x10000` offset or add other images.

Expected result: esptool verifies the write and the node boots as `v1.17.1-hybrid-ps3-rc2`. Verify identity and saved settings afterward rather than assuming retention from the write scope alone.

## Acceptance checks

After flashing:

1. Confirm a clean boot without repeated resets.
2. Reconnect through BLE and verify ordinary Companion messaging.
3. From another Companion, verify that the hybrid forwards a real message and appears by name in its path.
4. Open repeater management and authenticate.
5. Verify Settings and run read-only CLI commands:

```text
ver
get repeat
get radio
neighbors
get charge
get power
get temps
get gps
```

Expected results include `v1.17.1-hybrid-ps3-rc2`, `get repeat` returning exactly `> on`, and the intended radio profile. The GUI should show repeat enabled; disabling it is deliberately rejected. Confirm forwarding with BLE connected as well as disconnected. Read [Power settings](POWER.md) before selecting a higher USB input limit.

## Rollback

Keep a known-compatible previous application and its hash before updating. With the same verified layout/boot selection, an app-only rollback writes that previous application at `0x10000`; it does not revert user-data changes made by firmware. A full private backup can restore more state but overwrites the whole device and must be treated as a separate recovery operation. Do not use another person's full-flash image. No actual rc2-to-previous restoration test is claimed by this release.
