# MeshCore T-Beam Hybrid

Experimental, unofficial MeshCore firmware for one specific board family. It keeps a LilyGO T-Beam usable as a normal BLE Companion while also providing persistent packet forwarding, a named repeater presence on LoRa, and authenticated repeater-style remote management.

This repository is not affiliated with or endorsed by the MeshCore project.

## What works

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

The script clones the exact upstream revision into `work/MeshCore`, applies the three patches and builds the power-saving target. Build outputs are created under:

```text
work/MeshCore/.pio/build/Tbeam_SX1276_companion_radio_ble_ps/
```

See [Flashing](docs/FLASHING.md) before writing a device.

## Firmware identity

```text
v1.17.1-hybrid-ps2
```

The hardware-validated application image had SHA256:

```text
aade3f34c72159074c11bd06c4ddc24035183d309df03fccd4096e6cd7fe5517
```

That binary is intentionally not committed: its compiler diagnostics contained a local build path. Build locally from the reviewed source and patches.

## Architecture

The hybrid uses one MeshCore identity and key:

- BLE Companion self-info remains a CHAT node.
- LoRa self-adverts use the REPEATER type so route hops resolve by name and clients expose repeater management.
- Forwarding is locked on and persists independently of a phone connection.
- Remote administration reuses MeshCore's `ClientACL`, authentication protocol and `CommonCLI` implementation.
- The first hybrid boot seeds the admin password from the persisted six-digit BLE PIN when no admin password exists. Change it after the first successful login.

See [Architecture and limitations](docs/ARCHITECTURE.md) for details.

## Validation

The exact T-Beam above was exercised with real LoRa traffic and MeshCore One. BLE Companion messaging, packet forwarding, named hop attribution, remote login, telemetry, settings and tagged CLI commands passed. See [Validation](docs/VALIDATION.md).

## Security and privacy

Never publish a full flash dump, NVS image, SPIFFS image, private key, contact database, password, ACL dump or unsanitized device log. See [Security](SECURITY.md).

## Upstream status

MeshCore already supports restricted Companion Repeat, but a fully managed one-identity Companion/repeater remains an architectural edge case. This implementation should be treated as a working proof of concept and a basis for upstream discussion, not a finished cross-platform feature.

Relevant upstream discussions and contribution notes are collected in [Upstream](docs/UPSTREAM.md).

## License

MeshCore and these modifications are distributed under the MIT License. See [LICENSE](LICENSE).
