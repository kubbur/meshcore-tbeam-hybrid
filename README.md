# MeshCore T-Beam Hybrid

Experimental, unofficial MeshCore firmware for one specific board family. It keeps a LilyGO T-Beam usable as a normal BLE Companion while also providing persistent packet forwarding, a named repeater presence on LoRa, and authenticated repeater-style remote management.

This repository is not affiliated with or endorsed by the MeshCore project.

## Current prerelease: ps3-rc2

[Download v1.17.1-hybrid-ps3-rc2](https://github.com/kubbur/meshcore-tbeam-hybrid/releases/tag/v1.17.1-hybrid-ps3-rc2). The exact downloadable application was flashed, readback-verified and boot-checked on one T-Beam on 2026-09-22 (UTC). It is an experimental release, not a battery-life or charging-safety certification.

Changes since ps2:

- Guarded **1 A battery-charge target**, with separate saved 500/1500 mA USB input profiles.
- Corrected charging recovery: remove the separate 4.75 V recovery gate while keeping the 4.5 V low-input backoff, temperature/hardware checks and 60-second recovery delay.
- Real GPS power-rail/UART control when GPS is disabled, plus stale-fix rejection.
- Incoming messages no longer wake the OLED or extend its timeout; manual button wake remains.
- Improved idle handling, retaining the PowerSaving17 framework and always-available forwarding, including while connected through BLE.
- Explicit MCU/PMU temperature diagnostics; no misleading ambient/battery temperature claim.
- Corrected Remote Management's repeater switch response. Forwarding stays locked on; `get repeat` now returns the standard `> on` value.

**Actual charging current and battery-life gains have not been measured.** The firmware does not measure battery temperature. Deep sleep remains disabled/unvalidated. Read [Power settings and limitations](docs/POWER.md) before changing USB input limits.

## Hybrid capabilities

- Normal BLE Companion messaging with a single node identity
- Persistent forwarding using MeshCore's Companion Repeat path
- Named route-hop resolution in current clients
- Repeater adverts over LoRa while BLE self-info remains `ADV_TYPE_CHAT`
- Repeater authentication and admin ACL using MeshCore's existing protocol
- Remote status, telemetry, neighbours, settings and CLI in MeshCore One
- ESP32 and BLE power-saving behavior from the PowerSaving17 firmware family
- EU/UK Narrow operation at 869.618 MHz

## Tested hardware

- LilyGO T-Beam classic V1.2
- ESP32-D0WDQ6-V3 revision 3.1
- 4 MB SPI flash (`EF 4016`)
- SX1276 LoRa radio
- AXP2101 power-management IC
- Build target: `Tbeam_SX1276_companion_radio_ble_ps`

Other boards and radio variants are not validated.

## Important network warning

This build locks forwarding on. A mobile or unnecessary always-on forwarder can increase duplicate traffic, collisions and route instability on an established public mesh. Use it only where you understand the local channel plan and network impact. It is best suited to controlled testing, a deliberately planned vehicle node, or infrastructure-poor/off-grid use.

Radio operation is subject to local regulation. The included allowlist is a firmware safeguard, not a statement that every listed frequency and power level is legal in every jurisdiction.

## Build

The patch series applies to MeshCore base commit:

```text
0679dbeffc504d562d2f09eb072fdc223f8ffc2a
```

With Git and PlatformIO installed:

```bash
bash scripts/build.sh
```

The script clones the exact upstream revision into `work/MeshCore`, checks and applies all seven patches, verifies the resulting source tree and builds the power-saving target. It refuses to replace an existing source directory and never flashes a device. Build outputs are created under:

```text
work/MeshCore/.pio/build/Tbeam_SX1276_companion_radio_ble_ps/
```

See [Flashing](docs/FLASHING.md) before writing a device.

## Firmware identity

```text
v1.17.1-hybrid-ps3-rc2
```

The application-only release asset (1,526,336 bytes), verified on the device at offset `0x10000`, has SHA256:

```text
ef7725e68dadc125b196ecadb5a49e0c5e493daaafd04525a07d49f45c5491ad
```

The binary, build record and checksum file are release assets, not source files in Git. The seven patches reconstruct source tree `6649a527e348645a32b41905d181dc1e62794c9f`, matching the clean build input byte-for-byte for tracked files. Different dependency/toolchain versions or build paths can produce different binary bytes; a local build is not required to have the published hash.

The previous [ps2 release](https://github.com/kubbur/meshcore-tbeam-hybrid/releases/tag/v1.17.1-hybrid-ps2) remains available. Its public clean binary is distinct from the older ps2 hardware-test image recorded in the historical validation notes.

## Architecture

The hybrid uses one MeshCore identity and key:

- BLE Companion self-info remains a CHAT node.
- LoRa self-adverts use the REPEATER type so route hops resolve by name and clients expose repeater management.
- Forwarding is locked on and persists independently of a phone connection.
- Remote administration reuses MeshCore's `ClientACL`, authentication protocol and `CommonCLI` implementation.
- The first hybrid boot seeds the admin password from the persisted six-digit BLE PIN when no admin password exists. Change it after the first successful login.

See [Architecture and limitations](docs/ARCHITECTURE.md) for details.

## Validation

The earlier ps2 hybrid was exercised with real LoRa traffic and MeshCore One. For ps3-rc2, clean hybrid/ordinary Companion builds, simulated-hardware tests and a real client-parser test passed; the exact release image passed app readback and a 40-second boot check. The owner subsequently reported that it looked good. Detailed rc2 RF, GUI, GPS, measured charging and battery-life acceptance has not been separately recorded. See [Validation](docs/VALIDATION.md) for the evidence boundary.

## Security and privacy

Never publish a full flash dump, NVS image, SPIFFS image, private key, contact database, password, ACL dump or unsanitized device log. See [Security](SECURITY.md).

## Upstream status

MeshCore already supports restricted Companion Repeat, but a fully managed one-identity Companion/repeater remains an architectural edge case. This implementation should be treated as a working proof of concept and a basis for upstream discussion, not a finished cross-platform feature.

Relevant upstream discussions and contribution notes are collected in [Upstream](docs/UPSTREAM.md).

## License

MeshCore and these modifications are distributed under the MIT License. See [LICENSE](LICENSE).
