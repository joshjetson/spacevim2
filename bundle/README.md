# `bundle/` — vendored plugins

This directory holds the plugins SpaceVim2 ships **with the repo** (currently 196).
They are not a build artifact and not optional scaffolding — they are how SpaceVim
delivers plugins, so please read this before adding, removing, or "cleaning up" anything here.

## How these plugins reach you

When you enable a layer, SpaceVim adds its plugins to the plugin manager (dein). For any
plugin whose path is under `bundle/`, `SpaceVim#plugins#add()` tags it `type = 'none'`
(see `autoload/SpaceVim/plugins.vim`), which tells dein:

> "This is a **local** plugin. Add it to `runtimepath` as-is. Do not clone it from GitHub."

The practical result:

- **No network needed.** Enable the `lsp` or `git` layer and the exact vendored copy loads
  immediately — no `git clone`, no rate limits, no "works on my machine."
- **Pinned & reproducible.** Everyone on a given SpaceVim2 commit runs the *same* plugin
  versions. This is why some plugins carry a version suffix (see below).
- **Patches survive.** Where SpaceVim carries a local fix to a plugin, it lives here.

The plugin manager itself — `bundle/dein.vim/` — is also vendored and prepended to
`runtimepath` at boot. You cannot download a plugin manager with the plugin manager, so
this one must ship in-tree.

## Getting, updating & overriding plugins

| You want to… | Do this |
|---|---|
| **Use a plugin** | Enable the layer that provides it (e.g. `[[layers]] name = "git"`). The vendored copy loads automatically. |
| **Add your own plugin** | In `~/.SpaceVim.d/init.toml`: `[[custom_plugins]]` with `repo = "author/name"`. Dein clones it from GitHub — your own plugins are **not** vendored. |
| **Update a vendored plugin** | Vendored copies are pinned to this repo. To pull a newer upstream, replace the directory (or point a `[[custom_plugins]]` entry at the newer repo, which shadows the layer's copy). |
| **Not load something** | Disable its layer, or use the layer's own toggle options. |

Vendored plugins are what you get out of the box; `custom_plugins` in your init.toml are
fetched live from GitHub. The two mechanisms coexist.

## Why some plugins have version suffixes

A few plugins are vendored at **multiple pinned versions** and selected by your Neovim
version at runtime (the layer builds the path by concatenation, e.g.
`'bundle/nvim-treesitter' . l:version`). Do **not** delete these as "duplicates" — each is
live for a different editor:

- `nvim-treesitter` (Vim / older Nvim) and `nvim-treesitter-0.9.1` (Nvim ≥ 0.8) — `layers/treesitter.vim`
- `telescope.nvim-0.1.2` / `-0.1.5` / `-0.1.8` — `layers/telescope.vim`
- `nvim-lspconfig` / `-0.1.3` / `-0.1.4` / `-latest` — `layers/lsp.vim`

## Catalog

Every directory below is referenced by a layer (or version-dispatched as above). Grouped by
what pulls it in:

**Core, UI & statusline (38)** — `dein.vim`, `vim-airline`, `vim-airline-themes`, `vim-startify`, `nerdtree`, `nerdtree-git-plugin`, `nvim-tree.lua`, `neo-tree.nvim`, `nui.nvim`, `vimfiler.vim`, `defx.nvim`, `defx-git`, `defx-icons`, `defx-sftp`, `nvim-web-devicons`, `tagbar`, `tagbar-makefile.vim`, `tagbar-proto.vim`, `indentLine`, `indent-blankline.nvim`, `vim-matchup`, `vim-better-whitespace`, `vim-cursorword`, `vim-choosewin`, `vim-grepper`, `vim-smoothie`, `scrollbar.vim`, `winbar.nvim`, `quickfix.nvim`, `clever-f.vim`, `open-browser.vim`, `nerdcommenter`, `flygrep.nvim`, `gruvbox`, `vim-clipboard`, `nvim-yarp`, `nvim-if-lua-compat`, `vim-hug-neovim-rpc`

**Completion, LSP & Treesitter (27)** — `nvim-lspconfig`(+`-0.1.3`/`-0.1.4`/`-latest`), `nvim-treesitter`, `nvim-cmp`, `cmp-buffer`, `cmp-path`, `cmp-cmdline`, `cmp-dictionary`, `cmp-nvim-lsp`, `cmp-neosnippet`, `lspkind-nvim`, `deoplete.nvim`, `deoplete-lsp`, `deoplete-dictionary`, `neosnippet.vim`, `neosnippet-snippets`, `vim-snippets`, `neco-syntax`, `neoinclude.vim`, `neopairs.vim`, `context_filetype.vim`, `CompleteParameter.vim`, `delimitMate`, `echodoc.vim`, `coc.nvim-release`

**Fuzzy find & file nav (15)** — `telescope.nvim-0.1.2`/`-0.1.5`/`-0.1.8`, `telescope-fzf-native.nvim`, `telescope-ctags-outline.nvim`, `telescope-menu`, `plenary.nvim`, `unite.vim`, `unite-sources`, `neomru.vim`, `neoyank.vim`, `LeaderF-snippet`, `LeaderF-neosnippet`, `vimproc.vim`, `vim-van`

**Git & GitHub (7)** — `vim-fugitive`, `gina.vim`, `git.vim`, `github.vim`, `github-issues.vim`, `vim-github-dashboard`, `vim-dispatch`

**Linting & formatting (4)** — `neomake`, `ale`, `neoformat`, `format.nvim` (syntastic is opt-in and fetched from GitHub, not vendored)

**Editing, motions & tools (41)** — `vim-surround`, `nvim-surround`, `vim-repeat`, `vim-easymotion`, `vim-easyoperator-line`, `hop.nvim`, `incsearch.vim`, `incsearch-fuzzy.vim`, `incsearch-easymotion.vim`, `vim-asterisk`, `wildfire.vim`, `vim-expand-region`, `vim-textobj-user`, `vim-textobj-entire`, `vim-textobj-indent`, `vim-textobj-line`, `splitjoin.vim`, `vim-jplus`, `vim-over`, `tabular`, `vim-table-mode`, `undotree`, `vim-mundo`, `vim-unstack`, `bookmarks.vim`, `calendar.vim`, `screensaver.vim`, `rainbow`, `cpicker.nvim`, `vim-emoji`, `vim-grammarous`, `editorconfig-vim`, `cscope.vim`, `gtags.vim`, `SourceCounter.vim`, `vim-cheat`, `vim-chat`, `Chatting-server`, `vim-tmux-navigator`, `vim-bepo`, `fcitx.vim`

**Colorschemes (3)** — `dracula`, `vim-one`, `vim-hybrid` (the built-in `SpaceVim` + `gruvbox` themes live elsewhere; enable the `colorscheme` layer for more)

**Language layers (55)** — `vim-go`, `deoplete-go`, `rust.vim`, `jedi-vim`, `deoplete-jedi`, `python-imports.vim`, `vim-pythonsense`, `vim-python-pep8-indent`, `vim-pydocstring`, `coveragepy.vim`, `vim-virtualenv`, `vim-ruby`, `vim-scala`, `vim-javacomplete2`, `java_getset.vim`, `JavaUnit.vim`, `phpcomplete.vim`, `phpcomplete.vim-vim7`, `vim-lua`, `vim-teal`, `vim-markdown`, `vim-markdown-toc`, `vim-asciidoc`, `org-mode`, `vim-toml`, `vim-jsonnet`, `vim-jsx-typescript`, `vim-liquid`, `vim-haxe`, `vim-fsharp`, `deoplete-fsharp`, `vim-reason`, `vim-rescript`, `vim-cmake`, `vim-cmake-syntax`, `plantuml-syntax`, `plantuml-previewer.vim`, `vim-slumlord`, `fortran.vim`, `verilog`, `vim-assembly`, `vim-autohotkey`, `vim-postscript`, `vim-povray`, `vim-qml`, `yang.vim`, `smalltalk`, `octave`, `vim-elang`, `vim-jr`, `vim-dict`, `vim-lookup`, `helpful.vim`, `VimRegStyle`, `neodev.nvim`

**Other layers (5)** — `xmake.vim`, `vim-mail`, `vim-zettelkasten`, `django-plus.vim`, `ChineseLinter.vim`

---

*Maintainer note:* everything here is tracked in git. A directory earns its place by being
referenced from a layer via a `bundle/<name>` path (or version-dispatched by concatenation).
Before removing anything, confirm no layer references it **and** that no layer builds its
path dynamically (the treesitter/telescope/lspconfig version pins are reached that way and
will look "unreferenced" to a naive grep). See the three cross-editor gates in `build/`.
