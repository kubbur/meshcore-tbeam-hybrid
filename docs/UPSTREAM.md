# Upstream context

This proof of concept sits between two existing MeshCore directions:

- Companion Repeat, intended for restricted off-grid/camp scenarios
- Repeater remote management and named route-hop behavior

Relevant upstream threads:

- [Camp Mode discussion #1650](https://github.com/meshcore-dev/MeshCore/discussions/1650)
- [Repeater with local BLE/Wi-Fi clients #605](https://github.com/meshcore-dev/MeshCore/issues/605)
- [Companion Node Relay #2396](https://github.com/meshcore-dev/MeshCore/issues/2396)
- [Car Repeater build #2261](https://github.com/meshcore-dev/MeshCore/issues/2261)

MeshCore's contribution guide asks contributors to discuss larger features and obtain rough maintainer approval before opening a pull request. A future upstream submission should:

1. Start from the current `dev` branch, not the pinned validation commit.
2. Separate generic architecture from the T-Beam-specific target.
3. Retain the frequency and network-impact safeguards around Companion Repeat.
4. Add automated tests for role presentation, preferences compatibility, login/ACL, tagged CLI and reboot persistence.
5. Preserve ordinary Companion and stock repeater builds as regression targets.

This repository publishes the validated implementation and evidence so that discussion can proceed from working code rather than a hypothetical design.
