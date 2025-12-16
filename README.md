# sway-displays

A simple interactive display manager for Sway.

## Features

- **Interactive setup wizard** - Configure multi-monitor setups with guided prompts for position, rotation, and scaling
- **Profile system** - Save and load display configurations for different setups (docked, portable, etc.)
- **Display mirroring** - Mirror all outputs to a single display
- **Smart positioning** - Automatically calculates positions based on relative placement (left/right/above/below)

## Installation

```bash
git clone https://github.com/pescheckit/sway-displays.git
cd sway-displays
chmod +x sway-displays
sudo ln -s "$(pwd)/sway-displays" /usr/local/bin/sway-displays
```

This clones the repository, makes the script executable, and creates a symlink so you can run `sway-displays` from anywhere.

## Dependencies

- [Sway](https://swaywm.org/) (Wayland compositor)
- `jq` (JSON processor)
- `bc` (calculator)
- [sway-mirror](https://github.com/pescheckit/sway-mirror) (only required for mirroring)

### Installing sway-mirror

```bash
# Clone and build sway-mirror
git clone https://github.com/pescheckit/sway-mirror.git
cd sway-mirror
cargo build --release

# Optional: install to PATH
sudo cp target/release/sway-mirror /usr/local/bin/
```

If `sway-mirror` is not in your PATH, place the `sway-mirror` repository next to `sway-displays` and it will be found automatically.

## Usage

```bash
sway-displays <command> [args]
```

### Commands

| Command | Description |
|---------|-------------|
| `list` | Show connected displays |
| `setup` | Interactive setup wizard |
| `mirror [output]` | Mirror all displays to one output |
| `save [name]` | Save current configuration as a profile |
| `load [name]` | Load a saved profile |
| `profiles` | List saved profiles |
| `help` | Show help message |

### Examples

```bash
# List all connected displays
sway-displays list

# Start the interactive setup wizard
sway-displays setup

# Save current config as "docked"
sway-displays save docked

# Load the "docked" profile
sway-displays load docked
# or simply:
sway-displays docked

# Mirror all displays
sway-displays mirror
```

## Profiles

Profiles are stored as JSON files in `~/.config/displays/`. You can manually edit them or copy them between machines.

## License

MIT
