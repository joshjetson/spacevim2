<h1 align="center">
  <a href="https://github.com/joshjetson/spacevim2">
    <img src="assets/spacevim2-banner.svg" width="740" alt="SpaceVim2 — Modular Vim & Neovim, revived"/>
  </a>
</h1>

<p align="center">
  <b>A modular, layer-based distribution for Vim &amp; Neovim</b> — a maintained
  revival of <a href="https://github.com/SpaceVim/SpaceVim">SpaceVim</a> after its
  original author archived it. Same design, cleaned up and kept working
  <i>the same way</i> on both editors.
</p>

<p align="center">
  <a href="LICENSE"><img src="https://img.shields.io/badge/license-GPLv3-5fd7ff.svg" alt="GPLv3"/></a>
  <img src="https://img.shields.io/badge/editors-Vim%20·%20Neovim%200.10+-8ab4ff.svg" alt="Vim and Neovim 0.10+"/>
  <img src="https://img.shields.io/badge/tests-81%20on%20both%20editors-ff875f.svg" alt="81 tests on both editors"/>
  <img src="https://img.shields.io/badge/status-baseline%20release-3fb950.svg" alt="baseline release"/>
</p>

<p align="center">
  <a href="#install">Install</a> ·
  <a href="#configure">Configure</a> ·
  <a href="#features">Features</a> ·
  <a href="#docs--help">Docs &amp; help</a> ·
  <a href="doc/SpaceVim.txt"><code>:h SpaceVim</code></a>
</p>

---

## Why SpaceVim2?

SpaceVim organizes Vim/Neovim plugins and settings into **layers** — flip a
language or feature on in one line of TOML and its plugins, keybindings, and
config come with it. Inspired by Spacemacs, it keeps you out of the business of
hand-managing packages.

Upstream is archived. **SpaceVim2 picks it up**, with three priorities:

- **One config, both editors.** SpaceVim historically drifted between Vim and
  Neovim — things that worked in one quietly broke in the other. We hunt those
  divergences down (config parsing, statusline, tabline so far) and lock each one
  with a dual-editor test.
- **Smaller and clearer.** ~630k lines of dead weight removed, dead abstractions
  collapsed, the vendored plugin set documented in [`bundle/`](bundle/README.md).
- **Actually tested.** 81 checks run on **both** Vim and Neovim on every change.

## Install

```sh
curl -sLf https://raw.githubusercontent.com/joshjetson/spacevim2/master/install.sh | bash
```

Clones SpaceVim2 into `~/.SpaceVim` and wires up Vim/Neovim. Open your editor and
the plugins install themselves.

| You want to… | Add |
| --- | --- |
| install for one editor only | `-s -- --install vim` &nbsp;·&nbsp; `-s -- --install neovim` |
| remove everything | `-s -- --uninstall` |
| see all options | `bash install.sh -h` |

> Served from GitHub — not the retired `spacevim.org`.

## Configure

Your config lives in **`~/.SpaceVim.d/init.toml`** (open it anytime with
`SPC f v d`). Enabling a layer or changing an option is a single line:

```toml
[options]
    colorscheme = "gruvbox"      # switch the theme — applies on next start

[[layers]]
    name = "lang#python"         # turn a language on and get its whole toolchain
```

Options and themes are read **identically on Vim and Neovim** — that's the parity
work in action. Built-in `SpaceVim` and `gruvbox` themes work out of the box; add
the `colorscheme` layer for more.

## Features

- **Layer system** — related plugins, keys, and config grouped and toggled together.
- **Vim ⇔ Neovim parity** — the same `init.toml` yields the same editor, verified by tests.
- **Lazy by default** — most plugins load on-demand via [dein.vim](https://github.com/Shougo/dein.vim), so startup stays quick.
- **Mnemonic keybindings** — a `SPC`-led guide appears as you type; nothing to memorize blind.
- **Lua-accelerated core** — Neovim runs Lua implementations of core plugins; vimscript works everywhere.
- **Offline, pinned plugins** — everything ships vendored, so enabling a layer needs no network.

## Docs & help

- **In your editor:** `:h SpaceVim` — the help ships in this repo ([`doc/SpaceVim.txt`](doc/SpaceVim.txt)).
- **Guides:** the upstream English docs still describe the shared design —
  [Quick Start](https://github.com/SpaceVim/SpaceVim/blob/master/docs/quick-start-guide.md) ·
  [Documentation](https://github.com/SpaceVim/SpaceVim/blob/master/docs/documentation.md) ·
  [Layers](https://github.com/SpaceVim/SpaceVim/blob/master/docs/layers.md).

> `spacevim.org` is retired; the links above point at the maintained English docs
> on GitHub. SpaceVim2 will grow its own over time.

## Project layout

```txt
autoload/SpaceVim.vim       core bootstrap
autoload/SpaceVim/api/      public vimscript APIs
autoload/SpaceVim/layers/   the layers you enable in init.toml
lua/spacevim/               Lua implementations (Neovim)
colors/                     the built-in SpaceVim theme
bundle/                     vendored plugins  →  bundle/README.md
doc/                        :h SpaceVim
test/                       vader tests, run on Vim + Neovim
```

## Contributing

SpaceVim2 stands on the work of everyone who built SpaceVim. Issues and PRs are
welcome — the dual-editor test suite in [`test/`](test/) keeps changes honest across
both editors.

## Credits

- **[SpaceVim](https://github.com/SpaceVim/SpaceVim)** by [Wang Shidong (@wsdjeg)](https://github.com/wsdjeg) and its contributors — the project SpaceVim2 continues.
- [Spacemacs](https://www.spacemacs.org/) — the community Emacs distribution that inspired the layer model.
- [dein.vim](https://github.com/Shougo/dein.vim) — the plugin manager SpaceVim2 builds on.
- Authors of every bundled plugin — catalogued in [`bundle/README.md`](bundle/README.md).

<!-- vim:set nowrap: -->
