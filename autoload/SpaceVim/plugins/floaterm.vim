"=============================================================================
" floaterm.vim --- terminal buffers for SpaceVim2
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://github.com/joshjetson/spacevim2
" License: GPLv3
"=============================================================================
scriptencoding utf-8

" Terminals as normal, listed buffers -- opened like files. `SPC '` opens a
" terminal in the current window; open as many as you like and switch between
" them and your files with ordinary navigation: the tabline, `SPC b`, :bnext,
" <C-w>. Nothing special about the window -- it's just a buffer.
"
" Inside a terminal:
"   i / a   -> TYPING   (keys go to the shell; this is the default on open)
"   <Esc>   -> NAVIGATE (Vim's Terminal-Normal): motions, visual select, y to copy
"   <C-v>   -> paste the last yank while typing
"   P       -> (from NAVIGATE) paste the last yank and drop into TYPING

let s:count = 0

function! s:shell() abort
  return empty(&shell) ? 'sh' : &shell
endfunction

" send a register's text into THIS buffer's shell (a Vim yank can't be `p`-ed
" into a terminal -- the shell owns its line -- so we feed the job directly).
function! s:paste(reg) abort
  let l:text = getreg(a:reg)
  if empty(l:text)
    return
  endif
  if has('nvim')
    let l:job = getbufvar('%', 'terminal_job_id', 0)
    if l:job | call chansend(l:job, l:text) | endif
  else
    call term_sendkeys(bufnr('%'), l:text)
  endif
endfunction

" modal keys, buffer-local to each terminal (tnoremap fires in window terminals)
function! s:setup_keys() abort
  tnoremap <buffer><silent> <Esc> <C-\><C-n>
  tnoremap <buffer><silent> <C-v> <Cmd>call <SID>paste('"')<CR>
  nnoremap <buffer><silent> P     <Cmd>call <SID>paste('"')<CR>i
endfunction

" sidebar filetypes a terminal must never open INTO (it would inherit the tree's
" narrow size/position). Opening from one of these should behave like opening a
" file: jump to a normal editing window first.
let s:sidebars = ['nerdtree', 'defx', 'vimfiler', 'NvimTree', 'neo-tree', 'startify',
      \ 'tagbar', 'vista', 'vista_kind', 'undotree', 'Mundo', 'SpaceVimFileTree']

function! s:is_sidebar(winid) abort
  return index(s:sidebars, getbufvar(winbufnr(a:winid), '&filetype')) >= 0
endfunction

" move out of a file-tree / sidebar window so the terminal opens like a file
function! s:goto_editable() abort
  if !s:is_sidebar(win_getid())
    return
  endif
  wincmd p
  if s:is_sidebar(win_getid())
    for l:w in range(1, winnr('$'))
      if !s:is_sidebar(win_getid(l:w))
        execute l:w . 'wincmd w'
        return
      endif
    endfor
    " every window is a sidebar -> open a normal split to hold the terminal
    wincmd l
  endif
endfunction

" open a fresh terminal in a normal editing window, as a listed buffer
function! SpaceVim#plugins#floaterm#open() abort
  call s:goto_editable()
  if has('nvim')
    enew
    call termopen(s:shell())
  else
    execute 'terminal ++curwin ++kill=hup'
  endif
  let s:count += 1
  silent! execute 'keepalt file [terminal ' . s:count . ']'
  setlocal buflisted
  call s:setup_keys()
  startinsert
endfunction

" reported state, for tests/probes
function! SpaceVim#plugins#floaterm#status() abort
  return {
        \ 'bufnr'       : bufnr('%'),
        \ 'is_terminal' : &buftype ==# 'terminal',
        \ 'buflisted'   : &buflisted,
        \ }
endfunction

" vim:set et sw=2 cc=80:
