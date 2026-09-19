# Flashing

Flashing firmware can leave a device unbootable if power or USB is interrupted. Confirm the exact board, radio and flash layout before writing. Back up the complete device first and keep that backup private.

## Build outputs

After `bash scripts/build.sh`, the relevant files are under:

```text
work/MeshCore/.pio/build/Tbeam_SX1276_companion_radio_ble_ps/
```

- `firmware.bin`: application image for offset `0x10000`
- `firmware-merged.bin`: bootloader, partition table, boot selector and application, starting at `0x0`

## Preserve identity and settings

The tested partition layout stores NVS at `0x9000` and SPIFFS at `0x3d0000`. An application-only write at `0x10000` does not target those partitions. Do not use an erase command unless you intentionally want to destroy the device identity and settings.

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

Expected result: esptool verifies the write and the node boots as `v1.17.1-hybrid-ps2` while retaining its identity and settings.

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
```

Expected results include `v1.17.1-hybrid-ps2`, repeat enabled/locked and the intended radio profile.
