# sway-displays

Interactive display manager for Sway.

## Install

### APT (Debian/Ubuntu)

```bash
curl -fsSL https://pescheckit.github.io/sway-displays/gpg.key \
  | sudo gpg --dearmor -o /usr/share/keyrings/sway-displays.gpg

echo "deb [arch=amd64 signed-by=/usr/share/keyrings/sway-displays.gpg] \
https://pescheckit.github.io/sway-displays/apt stable main" \
  | sudo tee /etc/apt/sources.list.d/sway-displays.list

sudo apt update && sudo apt install sway-displays
```

### AUR (Arch Linux)

```bash
yay -S sway-displays
```

### Manual

```bash
curl -fsSL https://raw.githubusercontent.com/pescheckit/sway-displays/main/install.sh | bash
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
exec_always /usr/local/bin/sway-displays watch
```

This starts the watch daemon and restarts it on config reload. It runs in the background and automatically applies matching profiles when displays are plugged/unplugged. The daemon automatically kills any previous instance before starting.

## Profiles

Stored in `~/.config/displays/` as JSON files.

## License

MIT
