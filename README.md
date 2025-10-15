# aws-dev-env
A Nix flake for configuring Home Manager and development environments to ensure portable consistency across systems.

## Overview

This repository contains a Nix flake that provides:
- Home Manager configurations for consistent user environments across machines
- Development shells with pre-configured tooling
- direnv integration for automatic environment loading

## Prerequisites

- Nix package manager installed with flakes enabled
- Git for cloning this repository

To enable flakes, ensure your `~/.config/nix/nix.conf` contains:
```
experimental-features = nix-command flakes
```

## Initial Setup

### 1. Clone the Repository

```bash
git clone https://github.com/dustins/aws-dev-env.git ~/.config/aws-dev-env
cd ~/.config/aws-dev-env
```

### 2. Install Home Manager

If you don't already have home-manager installed:

```bash
nix run home-manager/master -- init --switch
```

### 3. Apply Home Manager Configuration

```bash
home-manager switch --flake .#clouddev
```

This will set up direnv, development tools, and other configurations specified in the flake.

## Updating Your Configuration

After making changes to the flake or wanting to update to the latest packages:

### Update flake inputs (get latest nixpkgs, etc.)
```bash
nix flake update
```

### Apply the updated configuration
```bash
home-manager switch --flake ~/.config/aws-dev-env#clouddev
```

### Or combine both steps
```bash
cd ~/.config/aws-dev-env && nix flake update && home-manager switch --flake .#clouddev
```

Consider creating a shell alias for convenience:
```bash
alias hms='home-manager switch --flake ~/.config/aws-dev-env#clouddev'
```

## Using Development Shells

### Manual Shell Activation

To manually enter a development shell:

```bash
nix develop .#myshell
```

Or for the default shell:

```bash
nix develop
```

### Automatic Loading with direnv

For automatic environment loading when entering project directories:

#### 1. Ensure direnv is configured in your Home Manager

This should already be set up if you've applied the home-manager configuration from this flake.

#### 2. Create `.envrc` in your project directory

```bash
cd /path/to/your/project
echo "use flake ~/.config/aws-dev-env#myshell" > .envrc
```

Or if your project has its own flake:

```bash
echo "use flake .#myshell" > .envrc
```

#### 3. Authorize direnv

```bash
direnv allow
```

Now the development environment will automatically load when you `cd` into the directory and unload when you leave.

## Available Development Shells

List the development shells provided by this flake:

```bash
nix flake show
```

[Document your specific shells here, for example:]
- `default` - Python and Node.js development environment
- `myshell` - Custom shell with additional tools

## Troubleshooting

### direnv not working
- Ensure your shell integration is active (restart your shell after initial setup)
- Check that `.envrc` is authorized with `direnv allow`

### Changes not taking effect
- Run `home-manager switch` again
- Check for errors in the flake with `nix flake check`

### Cache issues
- Clear direnv cache: `rm -rf ~/.local/share/direnv`
- Rebuild nix-direnv cache: `direnv reload`

## Repository Structure

```
.
├── flake.nix           # Main flake configuration
├── flake.lock          # Locked dependency versions
└── README.md           # This file
```
