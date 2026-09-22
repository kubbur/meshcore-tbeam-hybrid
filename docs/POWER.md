# ps3 power settings and limits

For the classic T-Beam V1.2 with SX1276 and AXP2101 only. Experimental firmware: actual charge current, battery temperature and battery-life gains have not been measured. Check the cell manufacturer's charge-current and temperature limits. Do not use the PMU-die reading as a battery-temperature measurement.

## Charging

The battery-charge **target** is 1000 mA at 4.2 V. A separate USB input profile defaults to 500 mA and can be explicitly set to 1500 mA to allow headroom for the board plus charging. These are current limits, not an ammeter reading; actual charging may be lower because of input capacity, protection, load or charge taper.

Using the existing authenticated remote Management CLI, inspect first:

```text
get power
get charge
get temps
get protections
```

On a verified supply/cable capable of at least 1.5 A at 5 V, with a compatible cell and supervised temperature/current testing:

```text
set usb limit 1500
get charge
```

This changes and saves the input limit. The firmware cannot identify the adapter. **Before returning to an unknown/weaker USB source**, select:

```text
set usb limit 500
```

The saved profile uses the new `hybrid_ps3` / `usb_ma` NVS entry. Existing identity, contacts, channels and preference formats are unchanged.

### Recovery correction in rc2

rc1's separate 4.75 V recovery gate could leave the requested charge limit at 500 mA indefinitely with reported VBUS around 4.66 V. rc2 removes only that extra gate. It retains:

- Low-input backoff below 4.5 V, hardware thermal/input-limit checks and PMU-die backoff at 80 C.
- Recovery only after 60 seconds of healthy samples, VBUS at least 4.5 V and PMU die at most 70 C.
- A 1000 mA charge ceiling, 4.2 V target checks, invalid-read handling and write/readback verification.

Five-second samples drive this software policy. Failed samples request a 0 mA constant-current limit; a bad/unverified charge-voltage setting remains latched conservative until restart. Neither is proof of complete charger isolation, and a failed I2C write cannot guarantee that a requested change occurred. Hardware charging may continue when application supervision stops.

Hardware protection thresholds/timers were not relaxed. The inherited TS configuration is disabled: **this change supplies no battery-temperature measurement or battery-temperature protection**. Cell, cable and enclosure testing remains necessary; stop on abnormal heating, voltage sag or resets. This is not a recommendation to exceed the board or cell rating.

## GPS, display and idle

- GPS off disables its UART and ALDO3 power rail; it does not switch ALDO2/radio power. Saved GPS preference is retained. Stale/undated fixes are rejected, while separately saved advert coordinates can remain the last location.
- Incoming messages update previews/unread counts without waking the OLED or extending the timer. Manual button wake and approximately 15-second timeout remain.
- Bounded idle waits and BLE pacing retain the PowerSaving17 framework, CPU scaling and BLE sleep setup. No measured light-sleep residency or battery-life increase is claimed.
- `get temps` labels uncalibrated MCU die and PMU die readings; battery and ambient temperatures are unavailable. The old generic internal-temperature telemetry field is omitted.
- Automatic deep sleep and periodic GPS power cycling are **not enabled**. A reset-on-radio-wake experiment would not preserve the current complete Companion session/message queue and is not part of this release.

Useful read-only commands:

```text
get gps
get rails
get idle
get sleep
get repeat
```

For MeshMapper on the T-Beam with a separate Wio L1 used for messaging, the intended workflow uses phone GPS for mapping, so the T-Beam GPS can remain off. Forwarding is not gated on BLE disconnection. Real simultaneous mapping/third-party forwarding is still an rc2 acceptance test, not a measured power result.

## Repeater GUI correction

`get repeat` now returns canonical `> on`, including an echoed correlation tag where requested. The previous `> on (locked)` was incompatible with MeshCore One's exact-value parser and could leave the Remote Management switch off. Actual forwarding remains locked on; `set repeat off` is still rejected. This is a response-format correction, not a role/identity change.

See [Validation](VALIDATION.md) for precisely what was tested and [Flashing](FLASHING.md) for the application-only update boundary.
