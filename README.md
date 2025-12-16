# sway-displays

Interactive display manager for Sway.

## Quick Start

```bash
git clone https://github.com/pescheckit/sway-displays.git
cd sway-displays
chmod +x sway-displays
sudo ln -s "$(pwd)/sway-displays" /usr/local/bin/sway-displays
```

## Requirements

- Sway
- `jq`
- `bc`
- Rust/Cargo (only for mirroring)

## Commands

```
list                  Show connected displays
setup                 Interactive setup wizard
mirror [output]       Mirror displays (auto-installs sway-mirror)
unmirror              Stop mirroring
save [name]           Save current config as profile
load [name]           Load a saved profile
profiles              List saved profiles
```

## Examples

```bash
sway-displays setup           # Interactive wizard
sway-displays save docked     # Save profile
sway-displays docked          # Load profile (shorthand)
sway-displays mirror          # Mirror displays
```

## Profiles

Stored in `~/.config/displays/` as JSON files.

## License

MIT
