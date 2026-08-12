# SpaceVim2 in Docker

This `Dockerfile` builds Neovim with SpaceVim2 preinstalled. Handy for:

- A consistent Neovim + SpaceVim2 anywhere Docker runs.
- Trying SpaceVim2 without touching your current Vim/Neovim config.
- Reproducing bug reports — if it happens in this clean container, it's likelier
  a real bug than a local-environment issue.

The image installs SpaceVim2 from this repository (`joshjetson/spacevim2`) and
runs `dein#install()` at build time so plugins are baked in.

## Build

Using the supplied `Makefile`:

```sh
make build
```

or directly:

```sh
docker build -t spacevim2 -f Dockerfile .
```

## Run

```sh
docker run -it spacevim2
```

Mount your working directory to edit real files:

```sh
docker run -it -v "$(pwd)":/home/spacevim/src spacevim2
```

A handy alias:

```sh
alias dvim='docker run -it -v "$(pwd)":/home/spacevim/src spacevim2'
```

## FAQ

**Isn't Docker stateless — won't plugins reinstall each launch?**
No. The build calls `dein#install()`, so plugins are installed and frozen into
the image. Add your own `~/.SpaceVim.d/init.toml` with a `COPY` step to customize.
