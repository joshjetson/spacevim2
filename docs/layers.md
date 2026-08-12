# Layers

[← Home](../README.md) · [Quick Start](../README.md#quick-start) · [Configuration](configuration.md) · **Layers**

A **layer** is a bundle of plugins, key bindings, and configuration that work
together to provide a feature — a language toolchain, a fuzzy finder, a git
workflow. Instead of hand-picking and wiring individual plugins, you turn on a
layer and everything it needs comes with it.

## Contents

- [Enabling a layer](#enabling-a-layer)
- [Configuring a layer](#configuring-a-layer)
- [Disabling a layer](#disabling-a-layer)
- [Feature layers](#feature-layers)
- [Language layers](#language-layers)

## Enabling a layer

Add a `[[layers]]` block to `~/.SpaceVim.d/init.toml` and restart:

```toml
[[layers]]
    name = "git"

[[layers]]
    name = "lang#python"
```

## Configuring a layer

Layer options go in the same block, under the layer's `name`:

```toml
[[layers]]
    name = "autocomplete"
    auto_completion_return_key_behavior = "complete"
    auto_completion_tab_key_behavior = "smart"

[[layers]]
    name = "shell"
    default_position = "top"
    default_height = 30
```

Which options a layer accepts is documented in its help section — `:h SpaceVim`
— and in the layer source under `autoload/SpaceVim/layers/`.

## Disabling a layer

Set `enable = false` to turn off a default layer:

```toml
[[layers]]
    name = "checkers"
    enable = false
```

## Feature layers

Editor features, tools, and integrations. `core` is always on.

| Layer | What it adds |
| --- | --- |
| `autocomplete` | Completion engine (deoplete / nvim-cmp / coc), snippets |
| `checkers` | Linting / syntax checking (neomake, ale) |
| `format` | Code formatting (neoformat / format.nvim) |
| `lsp` | Language Server Protocol client (nvim-lspconfig on Neovim ≥ 0.10) |
| `treesitter` | Tree-sitter highlighting & text objects (Neovim ≥ 0.10) |
| `git` | Git integration (fugitive, gina), status, blame, commit |
| `github` | GitHub issues, dashboards |
| `VersionControl` | VCS-agnostic gutter signs and hunk navigation |
| `edit` | Extra editing motions & text objects (surround, expand-region, wildfire) |
| `incsearch` | Incremental, fuzzy, and easymotion-style search |
| `ui` | Sidebar, tabline, indent guides, file tree |
| `colorscheme` | Extra themes beyond the built-in `SpaceVim`/`gruvbox` |
| `tools` | Grep, calendar, bookmarks, source counter, cheat sheets |
| `debug` | Debugger integration |
| `test` | Test-runner integration |
| `shell` | Built-in terminal / shell split |
| `tmux` | tmux navigation and integration |
| `ssh` / `sudo` | Remote editing and privileged writes |
| `cscope` / `gtags` | Code cross-referencing databases |
| `foldsearch` / `exprfold` | Folding helpers |
| `indentmove` / `operator` | Indent-aware motions, extra operators |
| `chat` / `mail` / `games` | Chat client, mail, in-editor games |
| `org` / `zettelkasten` | Org-mode and note-taking |
| `chinese` / `japanese` | CJK helpers |
| `xmake` / `floobits` | Build system and collaborative editing |

**Fuzzy finders** (pick one): `fuzzy` (auto-selects the best available) or a
specific backend — `telescope` (Neovim ≥ 0.10), `denite`, `unite`, `leaderf`,
`fzf`, `ctrlp`, `ctrlspace`.

## Language layers

Each language layer is named `lang#<name>` and brings that language's syntax,
indentation, completion, and (where available) LSP/formatter wiring. Enable one
with:

```toml
[[layers]]
    name = "lang#rust"
```

Available:

`lang#WebAssembly` · `lang#actionscript` · `lang#agda` · `lang#asciidoc` ·
`lang#aspectj` · `lang#assembly` · `lang#autohotkey` · `lang#autoit` ·
`lang#batch` · `lang#c` · `lang#chapel` · `lang#clojure` · `lang#cmake` ·
`lang#coffeescript` · `lang#crystal` · `lang#csharp` · `lang#d` · `lang#dart` ·
`lang#dockerfile` · `lang#e` · `lang#eiffel` · `lang#elixir` · `lang#elm` ·
`lang#erlang` · `lang#extra` · `lang#factor` · `lang#fennel` · `lang#forth` ·
`lang#fortran` · `lang#foxpro` · `lang#fsharp` · `lang#go` · `lang#goby` ·
`lang#gosu` · `lang#graphql` · `lang#groovy` · `lang#hack` · `lang#haskell` ·
`lang#haxe` · `lang#html` · `lang#hy` · `lang#idris` · `lang#io` · `lang#ipynb` ·
`lang#j` · `lang#janet` · `lang#java` · `lang#javascript` · `lang#jr` ·
`lang#json` · `lang#jsonnet` · `lang#julia` · `lang#kotlin` · `lang#lasso` ·
`lang#latex` · `lang#liquid` · `lang#lisp` · `lang#livescript` · `lang#lua` ·
`lang#markdown` · `lang#matlab` · `lang#moonscript` · `lang#nim` · `lang#nix` ·
`lang#ocaml` · `lang#octave` · `lang#org` · `lang#pact` · `lang#pascal` ·
`lang#perl` · `lang#php` · `lang#plantuml` · `lang#pony` · `lang#postscript` ·
`lang#povray` · `lang#powershell` · `lang#processing` · `lang#prolog` ·
`lang#puppet` · `lang#purescript` · `lang#python` · `lang#qml` · `lang#r` ·
`lang#racket` · `lang#reason` · `lang#red` · `lang#rescript` · `lang#ring` ·
`lang#rst` · `lang#ruby` · `lang#rust` · `lang#s` · `lang#scala` · `lang#scheme` ·
`lang#sh` · `lang#slim` · `lang#smalltalk` · `lang#sml` · `lang#solidity` ·
`lang#splus` · `lang#sql` · `lang#supercollider` · `lang#swift` · `lang#swig` ·
`lang#tcl` · `lang#teal` · `lang#toml` · `lang#typescript` · `lang#v` ·
`lang#vala` · `lang#vbnet` · `lang#verilog` · `lang#vim` · `lang#vue` ·
`lang#wdl` · `lang#wolfram` · `lang#xml` · `lang#xquery` · `lang#yang` ·
`lang#zig`

---

[← Home](../README.md) · [Quick Start](../README.md#quick-start) · [Configuration](configuration.md) · **Layers**
