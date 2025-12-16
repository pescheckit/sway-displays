# sway-displays

A simple interactive display manager for Sway.

## Features

- **Interactive setup wizard** - Configure multi-monitor setups with guided prompts for position, rotation, and scaling
- **Profile system** - Save and load display configurations for different setups (docked, portable, etc.)
- **Display mirroring** - Mirror all outputs to a single display
- **Smart positioning** - Automatically calculates positions based on relative placement (left/right/above/below)

## Installation

```bash
# Clone the repository
git clone https://github.com/YOUR_USERNAME/sway-displays.git

# Make it executable and add to your PATH
chmod +x sway-displays/sway-displays
sudo ln -s "$(pwd)/sway-displays/sway-displays" /usr/local/bin/sway-displays
```

## Dependencies

- [Sway](https://swaywm.org/) (Wayland compositor)
- `jq` (JSON processor)
- `bc` (calculator)

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
