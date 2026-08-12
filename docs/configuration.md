# Configuration

[← Home](../README.md) · [Quick Start](../README.md#quick-start) · **Configuration** · [Layers](layers.md)

All of SpaceVim2 is configured from one file: **`~/.SpaceVim.d/init.toml`**.
Open it any time from inside the editor with `SPC f v d`.

## Contents

- [File structure](#file-structure)
- [Options](#options)
- [Themes](#themes)
- [Layers](#layers)
- [Custom plugins](#custom-plugins)
- [Bootstrap functions](#bootstrap-functions)
- [Per-project configuration](#per-project-configuration)

## File structure

`init.toml` has three kinds of sections:

```toml
# 1. global options
[options]
    colorscheme = "gruvbox"
    enable_guicolors = true

# 2. layers to enable (repeatable)
[[layers]]
    name = "git"

# 3. your own plugins (repeatable)
[[custom_plugins]]
    repo = "tpope/vim-repeat"
    merged = false
```

## Options

The common `[options]` settings. Every option is optional; sensible defaults
apply.

| Option | Type | Purpose |
| --- | --- | --- |
| `colorscheme` | string | Active theme. `SpaceVim` and `gruvbox` are built in. |
| `colorscheme_bg` | `"dark"` / `"light"` | Background variant. |
| `enable_guicolors` | bool | Use 24-bit truecolor (needs a truecolor terminal). |
| `statusline_separator` | string | Statusline separator style: `arrow`, `curve`, `slant`, `bar`, `nil`. |
| `statusline_iseparator` | string | Inactive-segment separator style. |
| `buffer_index_type` | int | How buffers/tabs are numbered in the tabline (4 = plain `1 2 3`). |
| `windows_index_type` | int | How windows are numbered in the statusline. |
| `enable_tabline_filetype_icon` | bool | Show filetype icons in the tabline (needs nerd fonts). |
| `enable_statusline_mode` | bool | Show the mode name in the statusline. |
| `statusline_unicode` | bool | Use unicode separators (off = ASCII only). |
| `vimcompatible` | bool | Keep Vim's default key bindings where SpaceVim would remap them. |

> These options are read **identically on Vim and Neovim** — the same `init.toml`
> produces the same editor.

## Themes

Switch the theme by changing one line and restarting (or `:colorscheme <name>`
to preview live):

```toml
[options]
    colorscheme = "gruvbox"
```

`SpaceVim` and `gruvbox` ship built-in. For more (onedark, nord, molokai, …),
enable the `colorscheme` layer so they get installed, then set `colorscheme`:

```toml
[[layers]]
    name = "colorscheme"
```

`SPC T n` cycles installed themes; `SPC T s` picks one.

## Layers

Turn a feature or language on with a `[[layers]]` block. See the full catalog and
per-layer options in **[Layers](layers.md)**.

```toml
[[layers]]
    name = "lsp"

[[layers]]
    name = "lang#python"
```

## Custom plugins

Plugins not covered by a layer go in `[[custom_plugins]]`. They are fetched from
GitHub on install (`:SPInstall`), unlike layer plugins which ship vendored.

```toml
[[custom_plugins]]
    repo = "preservim/nerdtree"
    merged = false          # keep the plugin's own runtime layout
    # on_cmd = "NERDTreeToggle"   # optional: lazy-load on a command
```

## Bootstrap functions

For arbitrary vimscript, point SpaceVim at functions to run before and after it
starts:

```toml
[options]
    bootstrap_before = "myspacevim#before"
    bootstrap_after  = "myspacevim#after"
```

Put the functions in `~/.SpaceVim.d/autoload/myspacevim.vim`:

```vim
function! myspacevim#before() abort
    " runs before SpaceVim loads — set options, define mappings
endfunction

function! myspacevim#after() abort
    " runs after SpaceVim loads — override anything it set
endfunction
```

## Per-project configuration

A `.SpaceVim.d/init.toml` in a project's root is loaded on top of your global
config when you open files there — handy for enabling a language layer or LSP
server only where you need it.

---

[← Home](../README.md) · [Quick Start](../README.md#quick-start) · **Configuration** · [Layers](layers.md)
