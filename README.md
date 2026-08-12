<h1 align="center">
  <a href="https://github.com/joshjetson/spacevim2">
    <img src="assets/spacevim2-banner.svg" width="740" alt="SpaceVim2 — Modular Vim & Neovim, revived"/>
  </a>
</h1>

<p align="center">
  <b>A modular, layer-based distribution for Vim &amp; Neovim</b> — a maintained
  revival of SpaceVim after its original author archived it. Same design, cleaned
  up and kept working <i>the same way</i> on both editors.
</p>

<p align="center">
  <a href="LICENSE"><img src="https://img.shields.io/badge/license-GPLv3-5fd7ff.svg" alt="GPLv3"/></a>
  <img src="https://img.shields.io/badge/editors-Vim%208.0+%20·%20Neovim%200.10+-8ab4ff.svg" alt="Vim 8.0+ and Neovim 0.10+"/>
  <img src="https://img.shields.io/badge/tests-81%20on%20both%20editors-ff875f.svg" alt="81 tests on both editors"/>
  <img src="https://img.shields.io/badge/release-v2.5.0-3fb950.svg" alt="v2.5.0"/>
</p>

## Contents

- [Why SpaceVim2?](#why-spacevim2)
- [Requirements](#requirements)
- [Install](#install)
- [Quick start](#quick-start)
- [Configuration](#configuration)
- [Layers](#layers)
- [Key bindings](#key-bindings)
- [Themes](#themes)
- [Features](#features)
- [Update &amp; uninstall](#update--uninstall)
- [Help](#help)
- [Contributing](#contributing)
- [Credits](#credits)

**Guides:** [Quick Start](#quick-start) · [Configuration](docs/configuration.md) · [Layers](docs/layers.md) · in-editor `:h SpaceVim`

## Why SpaceVim2?

SpaceVim organizes Vim/Neovim plugins and settings into **layers** — flip a
language or feature on in one line of TOML and its plugins, key bindings, and
config come with it. Inspired by Spacemacs, it keeps you out of the business of
hand-managing packages.

The original project is archived. **SpaceVim2 picks it up**, with three priorities:

- **One config, both editors.** SpaceVim historically drifted between Vim and
  Neovim — things that worked in one quietly broke in the other. SpaceVim2 hunts
  those divergences down (config parsing, statusline, tabline so far) and locks
  each one with a test that runs on *both* editors.
- **Smaller and clearer.** ~630k lines of dead weight removed, dead abstractions
  collapsed, the vendored plugin set documented in [`bundle/`](bundle/README.md).
- **Actually tested.** 81 checks run on **both** Vim and Neovim on every change.

## Requirements

- **Vim 8.0+** or **Neovim 0.10+**
- `git` and `curl`
- A [Nerd Font](https://www.nerdfonts.com/) (optional — for icons and separators)
- Language tools on your `PATH` for the language layers you enable (compilers,
  formatters, language servers)

## Install

```sh
curl -sLf https://raw.githubusercontent.com/joshjetson/spacevim2/master/install.sh | bash
```

This clones SpaceVim2 into `~/.SpaceVim`, backs up any existing Vim/Neovim
config, and wires both editors to it. Open your editor and the plugins install
themselves.

| You want to… | Run |
| --- | --- |
| install for one editor only | `curl … \| bash -s -- --install vim` (or `neovim`) |
| skip font download | `curl … \| bash -s -- --no-fonts` |
| see all options | `bash install.sh -h` |

## Quick start

1. **Open your editor.** You land on the SpaceVim2 dashboard (recent files,
   sessions, bookmarks).
2. **Press `SPC`** (the spacebar) in normal mode. A **guide pops up** showing
   every command grouped by prefix — this is how you discover key bindings
   without memorizing them. Keep pressing keys to drill in, or `<Esc>` to back out.
3. **Open your config:** `SPC f v d` opens `~/.SpaceVim.d/init.toml`.
4. **Switch the theme:** change `colorscheme` in that file (see [Themes](#themes)).
5. **Turn on a language:** add a layer and restart —

   ```toml
   [[layers]]
       name = "lang#python"
   ```

6. **Install/refresh plugins** after editing config: `:SPInstall` then `:SPUpdate`.

That's the whole loop: edit `init.toml`, restart, use `SPC` to find what you need.

## Configuration

Everything is set in **`~/.SpaceVim.d/init.toml`** (`SPC f v d`). Options, layers,
and your own plugins each get a section:

```toml
[options]
    colorscheme = "gruvbox"      # theme — applies on next start

[[layers]]
    name = "git"                 # enable a feature

[[custom_plugins]]
    repo = "tpope/vim-repeat"    # add your own plugin
    merged = false
```

→ **Full reference: [docs/configuration.md](docs/configuration.md)** (all options,
custom plugins, bootstrap functions, per-project config).

## Layers

A **layer** bundles the plugins, key bindings, and config for one feature or
language, so you enable capabilities instead of wiring plugins:

```toml
[[layers]]
    name = "lsp"                 # language servers
[[layers]]
    name = "lang#rust"           # Rust toolchain
```

There are 160+ layers — languages (`lang#*`), completion, LSP, git, fuzzy
finders, UI, tools, and more.

→ **Full catalog: [docs/layers.md](docs/layers.md).**

## Key bindings

SpaceVim2 is **discoverable**: press **`SPC`** (space) and an on-screen guide
lists what's available, grouped by prefix. You never have to memorize blind.

| Prefix | Group | Prefix | Group |
| --- | --- | --- | --- |
| `SPC f` | Files | `SPC s` | Search |
| `SPC b` | Buffers | `SPC p` | Projects |
| `SPC w` | Windows | `SPC g` | Git |
| `SPC T` | Toggles / UI | `SPC q` | Quit |

A few to start with: `SPC f v d` (edit config) · `SPC f f` (find file) ·
`SPC b d` (close buffer) · `SPC w s` (split window) · `SPC q q` (quit). Press
`SPC` and explore the rest.

## Themes

`SpaceVim` and `gruvbox` are built in. Change the theme in one line:

```toml
[options]
    colorscheme = "SpaceVim"     # or "gruvbox"
```

For more themes, enable the `colorscheme` layer (installs onedark, nord, molokai,
…), then set `colorscheme`. `SPC T n` cycles installed themes. On a truecolor
terminal, set `enable_guicolors = true`.

## Features

- **Layer system** — related plugins, keys, and config grouped and toggled together.
- **Vim ⇔ Neovim parity** — the same `init.toml` yields the same editor, verified by tests.
- **Lazy by default** — most plugins load on-demand via [dein.vim](https://github.com/Shougo/dein.vim), so startup stays quick.
- **Mnemonic key bindings** — the `SPC` guide appears as you type; nothing to memorize.
- **Lua-accelerated core** — Neovim runs Lua implementations of core plugins; vimscript works everywhere.
- **Offline, pinned plugins** — everything ships vendored, so enabling a layer needs no network.

## Update & uninstall

- **Update SpaceVim2:** `cd ~/.SpaceVim && git pull`, then `:SPUpdate` in the editor.
- **Update plugins:** `:SPUpdate` (updates the manager and installed plugins).
- **Uninstall:** `curl -sLf https://raw.githubusercontent.com/joshjetson/spacevim2/master/install.sh | bash -s -- --uninstall`.

## Help

- **In your editor:** `:h SpaceVim` — the complete reference ships in this repo.
- **Guides:** [Configuration](docs/configuration.md) · [Layers](docs/layers.md) · [Bundled plugins](bundle/README.md).
- **Issues:** <https://github.com/joshjetson/spacevim2/issues>.

## Contributing

Issues and PRs are welcome. The dual-editor test suite in [`test/`](test/) keeps
changes honest across both editors — run it on Vim and Neovim before submitting.

## Credits

SpaceVim2 is a fork of **SpaceVim**, created by Wang Shidong (@wsdjeg) and its
contributors and released under the GPLv3 license. SpaceVim2 continues that work
under the same license, with all original copyright notices preserved in the
source. Thanks also to [Spacemacs](https://www.spacemacs.org/) for the layer
model, [dein.vim](https://github.com/Shougo/dein.vim) for plugin management, and
the authors of every [bundled plugin](bundle/README.md).

<!-- vim:set nowrap: -->
