# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

A Nix flake that provides a portable personal development shell. Running `nix develop github:bugeats/sh` drops into a tmux session with fish shell, helix editor, and gitui — all pre-configured with a custom color theme.

## Build & Test

```sh
nix build              # builds the default package (currently pkgs.hello placeholder)
nix build ./colors#    # builds the color palette (colors.py → colors.json)
nix develop            # enters the dev shell (launches tmux + fish)
nix flake check        # validates the flake
```

Files must be `git add`ed before `nix build` — flakes only see tracked files.

## Architecture

**`flake.nix`** — Root flake. Inputs: nixpkgs, flake-utils, a custom helix fork (`github:bugeats/hx`), a `path:./colors` sub-flake, and a non-flake path input for `config/`. The dev shell bundles fish, tmux, gitui, and helix. The `shellHook` wires config paths via `XDG_CONFIG_HOME` and `TMUX_CONF`, then auto-launches tmux with fish.

**`colors/`** — Sub-flake (derivation name: "amacrine"). `colors.py` defines the palette in HPLuv color space using functional HSL combinators (`pipe`, `dim`, `ansi`, `bright`, `alt`, `interp`). Builds to `colors.json` with hex and RGB output. Has its own `flake.lock`. Depends on Python + hsluv + colour-science (custom package). The `colors` binding is wired in the root flake's `let` block but not yet consumed programmatically — color values in tool configs are still applied manually.

**`config/`** — Tool configurations, mounted read-only from the Nix store at `$SHELL_CONFIG_ROOT`:
- `fish/config.fish` — prompt (user@host, cwd, git branch, lambda), aliases (`gs`, `gd`, `gl`, `gu`), `wip` function for checkpoint commits, editor set to `hx`
- `tmux/tmux.conf` — prefix rebound to `Ctrl+a`, vim-style pane navigation, vi copy mode
- `gitui/` — vim keybindings (`key_bindings.ron`) and terminal-color theme (`theme.ron`)

## Key Constraints

Configs live in the Nix store (read-only). They are path inputs to the flake, so changes require a flake lock update or `--override-input` during development.

## Current Focus

Colors sub-flake ported from `~/nix/home/colors/`. Next: wire `colors` output into config generation so tool themes derive from the palette programmatically instead of hardcoded hex values. Dead code in `colors.py` (unused imports, TODO functions for Oklab conversion) is a candidate for cleanup.
