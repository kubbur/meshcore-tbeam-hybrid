# Validation record

## ps3-rc2: 2026-09-22 (UTC)

Release: `v1.17.1-hybrid-ps3-rc2`. Same classic T-Beam V1.2 / ESP32-D0WDQ6-V3 rev 3.1 / 4 MB / SX1276 / AXP2101 hardware as below.

### Source and software checks

- Source tree: `6649a527e348645a32b41905d181dc1e62794c9f`. All seven public patches reconstruct this tree from upstream `0679dbeffc504d562d2f09eb072fdc223f8ffc2a`.
- All 889 tracked files match the archived input used for the clean firmware build. Private archive metadata, operator scripts, device logs and backups are not published.
- Clean power-saving target build: PASS. Program flash: 1,519,633 / 1,966,080 bytes. Static RAM report: 111,576 bytes against the configured 1,310,720-byte limit; not a runtime heap measurement.
- Clean ordinary BLE Companion regression build: PASS; that image is not a release asset.
- Host tests: PASS for recovery at the observed 4.658-4.671 V readings, 4.5 V boundary, thermal/input limiting, invalid reads, failed writes/readback, voltage-fault latching, GPS, display, idle policy and admin dispatch. Hardware dependencies are simulated.
- Unmodified MeshCore One `CLIResponse.swift` at commit `f841f2fe58d6992a2a4ba68a9a49e6b7b93269a1`: parser test PASS. `> on (locked)` is not parsed as enabled; `> on` and tagged `> on` are. This is not a phone-UI or LoRa test, and the installed phone app version was not inspected.
- Firmware/application SHA256: `ef7725e68dadc125b196ecadb5a49e0c5e493daaafd04525a07d49f45c5491ad` (1,526,336 bytes).

### Exact release-image hardware evidence

The user-run flash session started **2026-09-22T22:12:28.961009Z** and the terminal reported completion at **2026-09-22T22:14:52Z**.

- Target and existing flash layout checked before writing; application written only at `0x10000`.
- Application write verification and separate digest verification: PASS.
- Forty-second serial capture: rc2 version and exact target confirmed; SX1276 initialization and ESP32 power-management configuration reported success; no crash-loop/panic/backtrace evidence during that bounded capture.
- Bluetooth sleep success prefix present, with a corrupted tail in the capture. Actual sleep residency/current was not measured.
- PMU configuration reported verified: 1000 mA target, 1500 mA USB input profile and 4.2 V target. The prior saved USB profile loaded after the new boot. These are configuration limits, not measured charging current, and do not prove all settings were retained.
- NVS, SPIFFS, partition table and boot selector were not flash-write targets. No new full-flash backup, before/after user-data byte comparison or restore test was performed in that session.
- The owner subsequently reported "looks good" and approved publication. No detailed additional rc2 measurements or acceptance checklist were supplied.

### Still unverified for rc2

Measured charging current, cell/enclosure temperature and short-trip energy balance; battery-life gains; detailed GPS/OLED behavior; the actual phone repeat-switch state; BLE messaging and third-party forwarding while MeshMapper is connected; broader settings persistence after a separate reboot. Earlier hybrid results below are historical evidence, not a substitute for these rc2 checks.

The release is experimental. Neither a passing build nor a register readback establishes battery safety, measured 1 A charging or successful restoration. See [Power settings](POWER.md).

## Historical ps2 validation

Date: 2026-09-16 (Atlantic/Reykjavik / UTC). The following tables describe the earlier hardware-test image, **not** the ps3-rc2 image or the public ps2 clean rebuild.

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
