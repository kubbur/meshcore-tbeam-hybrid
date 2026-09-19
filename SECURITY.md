# Security and privacy

## Do not publish device data

A MeshCore full-flash backup can contain the node's private identity key, contacts, channels, passwords, ACL records and other user configuration. NVS and SPIFFS images must also be treated as sensitive.

Do not attach any of the following to issues or releases:

- Full flash, NVS or SPIFFS dumps
- Private keys or recovery material
- Admin or guest passwords
- BLE PINs
- Contact/channel databases
- Logs containing credentials, device addresses or personal filesystem paths

The repository's ignore rules block common dump and firmware extensions, but they are not a substitute for reviewing every staged file before pushing.

## First-login password

If no admin password exists, the hybrid initializes it from the six-digit BLE PIN on first boot. After confirming remote administration, use the remote CLI to replace it with a private password supported by the firmware. Do not paste that password into a public issue or retain terminal screenshots that expose it.

## Reporting vulnerabilities

For vulnerabilities in upstream MeshCore protocol or firmware, follow the upstream project's security policy. For a defect specific to this patch series, open an issue without including device secrets or exploit material that would put deployed nodes at immediate risk.
