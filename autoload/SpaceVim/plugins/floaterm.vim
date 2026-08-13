"=============================================================================
" floaterm.vim --- modal terminal for SpaceVim2
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://github.com/joshjetson/spacevim2
" License: GPLv3
"=============================================================================
scriptencoding utf-8

" A terminal you navigate like Vim.
"   - Neovim: a centered floating window (nvim_open_win) hosting a termopen buffer.
"   - Vim:    a large terminal WINDOW (term_start). Vim popup terminals can't
"             receive key mappings, so a window is used -- which makes <Esc> and
"             <F12> work exactly as on Neovim (verified: tnoremap fires in a
"             window terminal, never in a popup).
"
" Two modes inside the terminal:
"   TYPING   -- keys go to the shell (Terminal-Job mode). Enter with i / a.
"   NAVIGATE -- Vim's Terminal-Normal mode: full motions, visual select, `y` to
"               copy across words and lines. Enter with <Esc>.
"   <F12> hides the modal from either mode; the shell keeps running.
"
" Opens in NAVIGATE mode by default (press i / a to start typing).

let s:winid = -1
let s:bufnr = -1
let s:jobid = -1

" define the border highlight once (a hacker-ish green that reads on any bg)
function! s:hi() abort
  if !hlexists('SpaceVim_floaterm_border') || empty(synIDattr(synIDtrans(hlID('SpaceVim_floaterm_border')), 'fg'))
    highlight default SpaceVim_floaterm_border ctermfg=48 guifg=#5fd7af
  endif
endfunction

" centered geometry for the nvim float: ~80% of the grid -> [width,height,col,row]
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
  return has('nvim') ? nvim_win_is_valid(s:winid) : win_id2win(s:winid) > 0
endfunction

function! s:shell() abort
  return empty(&shell) ? 'sh' : &shell
endfunction

" a LIVE session = buffer exists AND its shell job is still running. After the
" user types `exit`, the buffer can linger as a finished terminal; treat that as
" dead so the next open() starts a fresh shell.
function! s:session_running() abort
  if s:bufnr <= 0 || !bufexists(s:bufnr)
    return 0
  endif
  if has('nvim')
    return s:jobid > 0 && jobwait([s:jobid], 0)[0] == -1
  else
    return term_getstatus(s:bufnr) =~# 'running'
  endif
endfunction

" tear down the current session: stop the job, wipe the buffer, clear state
function! s:reset_session() abort
  if s:bufnr > 0 && bufexists(s:bufnr)
    if has('nvim') && s:jobid > 0
      silent! call jobstop(s:jobid)
    endif
    silent! execute 'bwipeout! ' . s:bufnr
  endif
  let s:bufnr = -1
  let s:jobid = -1
endfunction

" map the modal keys on the terminal buffer. These fire in nvim floats and vim
" windows (but never in vim popups). <C-\><C-n> reaches Terminal-Normal on both
" editors, so the mappings are shared.
function! s:setup_keys() abort
  " from TYPING mode (Terminal-Job):
  tnoremap <buffer><silent> <Esc> <C-\><C-n>
  tnoremap <buffer><silent> <F12> <C-\><C-n>:call SpaceVim#plugins#floaterm#hide()<CR>
  " from NAVIGATE mode (Terminal-Normal is a normal mode):
  nnoremap <buffer><silent> <F12> :<C-u>call SpaceVim#plugins#floaterm#hide()<CR>
endfunction

function! SpaceVim#plugins#floaterm#open() abort
  call s:hi()
  if s:is_open()
    call win_gotoid(s:winid)
    return
  endif
  " previous shell exited? drop the dead buffer so we open a fresh terminal
  if !s:session_running()
    call s:reset_session()
  endif
  if has('nvim')
    call s:open_nvim()
  else
    call s:open_vim()
  endif
endfunction

function! s:open_nvim() abort
  let [w, h, c, r] = s:geometry()
  if s:bufnr <= 0 || !bufexists(s:bufnr)
    let s:bufnr = nvim_create_buf(v:false, v:true)
    let s:jobid = -1
  endif
  let l:conf = {
        \ 'relative' : 'editor', 'width' : w, 'height' : h, 'col' : c, 'row' : r,
        \ 'style' : 'minimal', 'border' : 'rounded',
        \ }
  if has('nvim-0.9.0')
    let l:conf.title = ' ❯ spacevim2 · terminal '
    let l:conf.title_pos = 'center'
  endif
  let s:winid = nvim_open_win(s:bufnr, v:true, l:conf)
  call setwinvar(s:winid, '&winhighlight', 'FloatBorder:SpaceVim_floaterm_border,FloatTitle:SpaceVim_floaterm_border')
  if s:jobid <= 0
    let s:jobid = termopen(s:shell())
  endif
  call s:setup_keys()
  " default NAVIGATE mode: termopen leaves us in Terminal-Normal already
  stopinsert
endfunction

function! s:open_vim() abort
  if s:bufnr <= 0 || !bufexists(s:bufnr)
    let s:bufnr = term_start(s:shell(), {
          \ 'hidden'      : 1,
          \ 'term_finish' : 'close',
          \ 'term_kill'   : 'hup',
          \ 'term_name'   : 'spacevim2 · terminal',
          \ })
    call setbufvar(s:bufnr, '&bufhidden', 'hide')
  endif
  " a large window (popups can't take key maps); big enough to feel modal
  botright split
  execute 'buffer ' . s:bufnr
  execute 'resize ' . max([float2nr(&lines * 0.85), 6])
  let s:winid = win_getid()
  setlocal winfixheight nonumber norelativenumber signcolumn=no
  call s:setup_keys()
  " default NAVIGATE mode: leave the terminal in Terminal-Normal (do not enter
  " job mode). Showing the buffer keeps us in normal mode; i / a starts typing.
  call feedkeys("\<C-\>\<C-n>", 'n')
endfunction

" hide the modal but keep the terminal (and its process) running
function! SpaceVim#plugins#floaterm#hide() abort
  if !s:is_open()
    return
  endif
  if has('nvim')
    call nvim_win_close(s:winid, v:false)
  else
    " close the window; the (hidden) terminal buffer keeps its shell running
    call win_execute(s:winid, 'close')
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
  call s:reset_session()
endfunction

" reported state, for tests/probes
function! SpaceVim#plugins#floaterm#status() abort
  return {'open' : s:is_open(), 'winid' : s:winid, 'bufnr' : s:bufnr, 'alive' : s:session_running()}
endfunction

" vim:set et sw=2 cc=80:
