"=============================================================================
" treesitter.vim --- treesitter layer for SpaceVim
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section treesitter, layers-treesitter
" @parentsection layers
" This layer provides treesitter support for SpaceVim.

function! SpaceVim#layers#treesitter#plugins() abort
  let plugins = []
  " nvim floor is 0.10 (>= 0.8), so the pinned nvim-treesitter-0.9.1 is always
  " the right one; the older unversioned pin was dropped.
  call add(plugins, [g:_spacevim_root_dir . 'bundle/nvim-treesitter-0.9.1',
        \ {
          \ 'merged' : 0,
          \ 'loadconf' : 1 ,
          \ 'do' : 'TSUpdate',
          \ 'loadconf_before' : 1
          \ }])
  return plugins
endfunction

function! SpaceVim#layers#treesitter#health() abort
  call SpaceVim#layers#treesitter#plugins()
  return 1
endfunction

function! SpaceVim#layers#treesitter#setup() abort

  lua require('spacevim.treesitter').setup()

endfunction

function! SpaceVim#layers#treesitter#loadable() abort

  return has('nvim-0.10.0')

endfunction
