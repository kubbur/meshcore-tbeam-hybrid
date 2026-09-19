# Architecture and limitations

## One identity, two presentations

The node retains one MeshCore identity and private key. It does not create a second repeater identity.

Direct BLE self-info remains `ADV_TYPE_CHAT`, preserving ordinary Companion behavior. LoRa self-adverts use `ADV_TYPE_REPEATER`, which lets existing clients resolve the device as a named route hop and expose repeater management without changing the mobile client.

This is deliberate protocol interoperation, not a claim that CHAT and REPEATER are interchangeable roles throughout MeshCore.

## Forwarding

The implementation uses the existing Companion Repeat forwarding path and locks it enabled. The stored setting survives reboot, and runtime code restores the enabled state after administrative commands.

Allowed repeat frequencies in this target are:

- 433.000 MHz
- 869.495 MHz
- 869.618 MHz
- 918.000 MHz

The tested profile was 869.618 MHz, 62.5 kHz bandwidth, spreading factor 8 and coding rate 8.

## Remote administration

Remote administration reuses upstream components rather than defining another protocol:

- `ClientACL`
- Anonymous authenticated login
- Existing shared-secret derivation
- Standard status and telemetry frames
- Binary neighbour/access-list requests
- `CommonCLI`

MeshCore One prefixes some CLI commands with a three-character correlation tag such as `01|`. The third patch mirrors stock repeater behavior by removing the tag before dispatch and returning it with the response.

## Power saving

The target uses the IoTThinks PowerSaving17 Arduino ESP32 2.0.17 package and preserves the earlier firmware family's BLE sleep and ESP32 power-management setup. LoRa receive remains available for forwarding.

## Intentionally restricted operations

The hybrid rejects operations that are unsafe or not meaningful for the Companion architecture, including disabling forwarding, remote OTA, temporary radio mode, region mutation, logging operations and several low-level forwarding controls.

Radio changes are accepted only when the requested frequency is in the Companion Repeat allowlist. TX power is range checked.

## Known limitations

- Validated on one T-Beam hardware configuration only.
- Based on a pinned MeshCore revision; it is not yet rebased onto the current `dev` branch.
- Current client behavior is relied upon for dual CHAT/REPEATER presentation.
- Permanent forwarding can be harmful on busy or carefully engineered meshes.
- A six-digit first-login credential should be replaced after commissioning.
- Not every stock repeater CLI operation is appropriate or enabled.
- BLE-disconnected forwarding was not recorded as a separate formal test case, although forwarding is implemented independently of the BLE connection.
