<h1 align="center">
<a href="https://github.com/joshjetson/spacevim2">
  <img src="https://raw.githubusercontent.com/SpaceVim/SpaceVim/master/docs/logo.png" width="440" alt="SpaceVim2"/>
  </a>
</h1>

<p align="center">
  <b>SpaceVim2</b> is a maintained continuation of
  <a href="https://github.com/SpaceVim/SpaceVim">SpaceVim</a> — the community
  distribution of Vim and Neovim — after its original author archived the
  project. It keeps the same modular, layer-based design while being cleaned up
  and kept working on both editors.
</p>

[Quick Start Guide](https://github.com/SpaceVim/SpaceVim/blob/master/docs/quick-start-guide.md) \|
[Documentation](https://github.com/SpaceVim/SpaceVim/blob/master/docs/documentation.md) \|
[Layers](https://github.com/SpaceVim/SpaceVim/blob/master/docs/layers.md) \|
[`:h SpaceVim`](doc/SpaceVim.txt)

[![GPLv3 License](https://img.shields.io/badge/license-GPLv3-blue.svg)](https://github.com/joshjetson/spacevim2/blob/master/LICENSE)

![work-flow](https://img.spacevim.org/workflow.png)


SpaceVim is a modular configuration of Vim and Neovim.
It's inspired by spacemacs. It manages collections of plugins in layers,
which help to collect related packages together to provide features.
This approach helps keep the configuration organized and reduces
overhead for the user by keeping them from having to think about
what packages to install.

> **Docs note:** the guide/documentation/layers links above point to the
> upstream SpaceVim English docs on GitHub (the archived `spacevim.org`
> website now redirects to a maintenance notice). SpaceVim2 will grow its
> own docs over time; the in-editor help (`:h SpaceVim`) ships in this repo.

## Features

- **Modularization:** plugins and functions are organized in [layers](https://github.com/SpaceVim/SpaceVim/blob/master/docs/layers.md).
- **Compatible api:** a series of [compatible APIs](https://github.com/SpaceVim/SpaceVim/blob/master/docs/api.md) for Vim/Neovim.
- **Great documentation:** English [documentation](https://github.com/SpaceVim/SpaceVim/blob/master/docs/documentation.md) and `:h SpaceVim`.
- **Better experience:** core plugins rewritten in lua.
- **Beautiful UI:** you'll love the awesome UI and its useful features.
- **Mnemonic key bindings:** key binding guide will be displayed automatically.
- **Fast boot time:** Lazy-load 90% of plugins with [dein.vim](https://github.com/Shougo/dein.vim).
- **Lower the risk of RSI:** by heavily using the space bar instead of modifiers.
- **Consistent experience:** consistent experience between terminal and gui.


## Project Layout

```txt
├─ .ci/                           build automation
├─ .github/                       issue/PR templates
├─ .SpaceVim.d/                   project specific configuration
├─ after/                         overrule or add to the distributed defaults
├─ autoload/SpaceVim.vim          SpaceVim core file
├─ autoload/SpaceVim/api/         public APIs
├─ autoload/SpaceVim/layers/      available layers
├─ autoload/SpaceVim/plugins/     builtin plugins
├─ autoload/SpaceVim/mapping/     mapping guide
├─ colors/                        default colorscheme
├─ docker/                        docker image generator
├─ bundle/                        bundled plugins
├─ lua/spacevim/                  core plugins/APIs rewritten in lua
├─ doc/                           in-editor help (`:h SpaceVim`, en/cn)
├─ bin/                           executables
└─ test/                          tests (vader)
```

## Contribute

SpaceVim2 builds on the work of everyone who contributed to SpaceVim.
We are thankful for any contributions from the community.

<a href="https://github.com/SpaceVim/SpaceVim/graphs/contributors"><img src="https://opencollective.com/spacevim/contributors.svg?width=890&button=false" /></a>

## Credits & Acknowledgements

- [SpaceVim](https://github.com/SpaceVim/SpaceVim) by [Wang Shidong (@wsdjeg)](https://github.com/wsdjeg) and its contributors — the original project SpaceVim2 continues.
- [Hack-SpaceVim](https://github.com/Gabirel/Hack-SpaceVim) by [@Gabirel](https://github.com/Gabirel)
- [SpaceVimTutorial](https://everettjf.gitbooks.io/spacevimtutorial/content/) by [@everettjf](https://github.com/everettjf)
- [10-minutes-to-SpaceVim](https://github.com/Jackiexiao/10-minutes-to-SpaceVim) by [@Jackiexiao](https://github.com/Jackiexiao)
- [A First Look At SpaceVim](https://www.youtube.com/watch?v=iXPS_NHLj9k) by [@DistroTube](https://www.youtube.com/channel/UCVls1GmFKf6WlTraIb_IaJg)
- [Getting Started With SpaceVim](https://www.youtube.com/watch?v=3xB501CJDB8) by [FOSS King](https://www.youtube.com/channel/UCfU_sitghekwveLh6yM_xuA)
- [vimdoc](https://github.com/google/vimdoc): Vim help file generator
- [spacemacs](https://www.spacemacs.org/): A community-driven Emacs distribution
- Authors of all the plugins used in SpaceVim.

<!-- vim:set nowrap: -->
