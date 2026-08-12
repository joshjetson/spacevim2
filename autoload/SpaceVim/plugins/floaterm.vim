"=============================================================================
" floaterm.vim --- floating terminal for SpaceVim2
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://github.com/joshjetson/spacevim2
" License: GPLv3
"=============================================================================
scriptencoding utf-8

" A detachable, centered, floating terminal modal that works on BOTH editors:
"   - Neovim: nvim_open_win() hosting a termopen() buffer.
"   - Vim:    popup_create() hosting a hidden term_start() buffer
"             (see :h popup-terminal). Vim supports one terminal popup at a
"             time, which suits a single centered modal; tabbed sessions (next
"             phase) keep only the active session in the popup.
"
" Phase 1: one session -- open / toggle / hide / close. Tabs + minimize come next.

let s:winid = -1
let s:bufnr = -1
let s:jobid = -1

" define the border highlight once (a hacker-ish green that reads on any bg)
function! s:hi() abort
  if !hlexists('SpaceVim_floaterm_border') || empty(synIDattr(synIDtrans(hlID('SpaceVim_floaterm_border')), 'fg'))
    highlight default SpaceVim_floaterm_border ctermfg=48 guifg=#5fd7af
  endif
endfunction

" centered geometry: ~80% of the editor grid -> [width, height, col, row]
function! s:geometry() abort
  let width  = max([float2nr(&columns * 0.8), 20])
  let height = max([float2nr(&lines * 0.8), 6])
  let col = (&columns - width) / 2
  let row = (&lines - height) / 2
  return [width, height, col, row]
endfunction

function! s:is_open() abort
  if s:winid <= 0
    return 0
  endif
  return has('nvim') ? nvim_win_is_valid(s:winid) : !empty(popup_getpos(s:winid))
endfunction

function! s:term_alive() abort
  return s:bufnr > 0 && bufexists(s:bufnr)
endfunction

function! s:shell() abort
  return empty(&shell) ? 'sh' : &shell
endfunction

" open (or reveal) the floating terminal; keeps the session alive across toggles
function! SpaceVim#plugins#floaterm#open() abort
  call s:hi()
  if s:is_open()
    if has('nvim')
      call nvim_set_current_win(s:winid)
      startinsert
    endif
    return
  endif
  let [w, h, c, r] = s:geometry()
  if has('nvim')
    if !s:term_alive()
      let s:bufnr = nvim_create_buf(v:false, v:true)
    endif
    let s:winid = nvim_open_win(s:bufnr, v:true, {
          \ 'relative'  : 'editor',
          \ 'width'     : w,
          \ 'height'    : h,
          \ 'col'       : c,
          \ 'row'       : r,
          \ 'style'     : 'minimal',
          \ 'border'    : 'rounded',
          \ 'title'     : ' ❯ spacevim2 · terminal ',
          \ 'title_pos' : 'center',
          \ })
    call setwinvar(s:winid, '&winhighlight', 'FloatBorder:SpaceVim_floaterm_border,FloatTitle:SpaceVim_floaterm_border')
    if s:jobid <= 0
      " termopen() turns the current (float) buffer into a terminal
      let s:jobid = termopen(s:shell())
    endif
    startinsert
  else
    if !s:term_alive()
      let s:bufnr = term_start(s:shell(), {
            \ 'hidden'      : 1,
            \ 'term_finish' : 'close',
            \ 'term_kill'   : 'hup',
            \ })
    endif
    let s:winid = popup_create(s:bufnr, {
          \ 'line'            : r + 1,
          \ 'col'             : c + 1,
          \ 'minwidth'        : w,
          \ 'maxwidth'        : w,
          \ 'minheight'       : h,
          \ 'maxheight'       : h,
          \ 'border'          : [1,1,1,1],
          \ 'borderchars'     : ['─','│','─','│','╭','╮','╯','╰'],
          \ 'borderhighlight' : ['SpaceVim_floaterm_border'],
          \ 'title'           : ' ❯ spacevim2 · terminal ',
          \ 'highlight'       : 'Normal',
          \ 'zindex'          : 200,
          \ })
  endif
endfunction

" hide the modal but keep the terminal (and its scrollback/process) running
function! SpaceVim#plugins#floaterm#hide() abort
  if !s:is_open()
    return
  endif
  if has('nvim')
    call nvim_win_close(s:winid, v:false)
  else
    call popup_close(s:winid)
  endif
  let s:winid = -1
endfunction

function! SpaceVim#plugins#floaterm#toggle() abort
  if s:is_open()
    call SpaceVim#plugins#floaterm#hide()
  else
    call SpaceVim#plugins#floaterm#open()
  endif
endfunction

" fully close: hide the modal, stop the job, wipe the terminal buffer
function! SpaceVim#plugins#floaterm#close() abort
  call SpaceVim#plugins#floaterm#hide()
  if s:term_alive()
    if has('nvim') && s:jobid > 0
      silent! call jobstop(s:jobid)
    endif
    silent! execute 'bwipeout! ' . s:bufnr
  endif
  let s:bufnr = -1
  let s:jobid = -1
endfunction

" reported state, for tests/probes
function! SpaceVim#plugins#floaterm#status() abort
  return {'open' : s:is_open(), 'winid' : s:winid, 'bufnr' : s:bufnr, 'alive' : s:term_alive()}
endfunction

" vim:set et sw=2 cc=80:
