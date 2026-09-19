# Validation record

Date: 2026-09-16 (Atlantic/Reykjavik)

## Device

| Item | Observed value |
|---|---|
| Board | LilyGO T-Beam classic V1.2 |
| MCU | ESP32-D0WDQ6-V3 revision 3.1 |
| Flash | 4 MB, manufacturer `EF`, device `4016` |
| Radio | SX1276 |
| PMIC | AXP2101 |
| Target | `Tbeam_SX1276_companion_radio_ble_ps` |
| Firmware | `v1.17.1-hybrid-ps2` |

## Build evidence

| Check | Result |
|---|---|
| Clean PlatformIO build | PASS |
| Framework | IoTThinks Arduino ESP32 2.0.17 |
| RAM | 111,456 / 1,310,720 bytes (8.5%) |
| Flash | 1,509,621 / 1,966,080 bytes (76.8%) |
| Application SHA256 | `aade3f34c72159074c11bd06c4ddc24035183d309df03fccd4096e6cd7fe5517` |
| Source commit | `5ba0a1b12d0bd4988d4661143b4a0f0a00d027b0` |

## Runtime evidence

| Behavior | Result |
|---|---|
| Basic boot without crash loop | PASS |
| SX1276/board initialization path reached | PASS |
| BLE sleep initialization | PASS |
| ESP32 power management initialization | PASS |
| Existing identity/settings retained across application update | PASS |
| Normal BLE Companion operation | PASS |
| Real LoRa packet forwarding | PASS |
| Repeater name displayed in another node's message path | PASS |
| Remote authenticated management login | PASS |
| Remote status and packet counters | PASS |
| Remote voltage and temperature telemetry | PASS |
| Remote neighbour list | PASS |
| MeshCore One radio/repeat settings readback | PASS after `ps2` tag fix |
| Remote CLI: `ver`, `get repeat`, `get radio`, `neighbors` | PASS after `ps2` tag fix |
| BLE-disconnected forwarding as a separately logged test | NOT SEPARATELY RECORDED |
| Other boards/radios | NOT TESTED |

## Observed management data

During validation, MeshCore One displayed live battery, uptime, airtime, RSSI, SNR, noise floor, packet counters, duplicates, receive errors, temperature and two neighbours. These observations establish live LoRa management responses; they are not simulated UI data.

## Rollback evidence

An original 4 MB device backup and the previously working hybrid application were retained privately. They are intentionally excluded from this public repository because full flash and filesystem images can contain secret identity and user data.
