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
- [Rust/Cargo](https://rustup.rs/) + wayland-dev libs (only for mirroring, see [sway-mirror](https://github.com/pescheckit/sway-mirror))

## Commands

```
list                  Show connected displays
setup                 Interactive setup wizard
save [name]           Save current config as profile
load [name]           Load a saved profile (auto-stops mirror)
profiles              List saved profiles
auto                  Auto-detect and load matching profile
watch                 Watch for display changes (daemon)
watch-stop            Stop the watch daemon
mirror [output] [opts] Mirror displays (auto-installs sway-mirror)
unmirror              Stop mirroring
```

### Mirror Options

```
-s, --scale <mode>     fit (default), fill, stretch, center
--cursor <bool>        Include cursor (default: true)
-w, --workspaces <bool> Move workspaces to source (default: true)
```

## Examples

```bash
sway-displays setup           # Interactive wizard
sway-displays save work       # Save profile
sway-displays work            # Load profile (shorthand)
sway-displays auto            # Auto-detect displays and load matching profile
sway-displays watch &         # Watch for changes in background

# Mirroring
sway-displays mirror          # Interactive mode (asks for options)
sway-displays mirror eDP-1    # Mirror eDP-1 to all others
sway-displays mirror eDP-1 -s fill  # Use fill scaling mode
sway-displays unmirror        # Stop mirroring
```

## Auto-Detection

Profiles are matched by hardware IDs (make/model/serial), not port names. This means:
- Save a profile at work → `sway-displays save work`
- Save a profile at home → `sway-displays save home`
- Plug in displays → `sway-displays auto` finds the right profile

Port names like `DP-1` or `DP-7` can change between docks - hardware IDs don't.

### Auto-apply on display change

Add to your sway config:
```
exec sway-displays watch
```

## Profiles

Stored in `~/.config/displays/` as JSON files.

## License

MIT
