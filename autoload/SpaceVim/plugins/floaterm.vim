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
" A terminal buffer has TWO cursors: Vim's (what NAVIGATE moves) and the shell's
" own input cursor (owned by the shell's line editor). Vim can't move the
" shell's cursor directly, so we bridge the two:
"
"   i / a   -> TYPING, resuming at the column you navigated to on the input line
"              (we translate Vim's column into shell left-arrows). i = before the
"              char under the cursor, a = after it. On any other line it just
"              resumes typing normally.
"   x       -> delete the char under the cursor          (from NAVIGATE)
"   dw / db -> delete the word forward / backward        (from NAVIGATE)
"   D       -> delete from the cursor to end of line     (from NAVIGATE)
"   dd      -> clear the whole input, even a multi-line paste  (from NAVIGATE)
"   v … d   -> highlight in visual mode, then d/x deletes the selection
"
" All of the above work on a multi-line paste too: left-arrows move one grapheme
" back through the whole buffer (wrapping newlines), so we count characters across
" rows (s:chars_to_end) to place the shell cursor, and dd floods backspaces to
" wipe the block whole.
"   <Esc>   -> NAVIGATE (Vim's Terminal-Normal): motions, visual select, y to copy
"   <C-v>   -> paste the last yank while typing          (never auto-runs)
"   P       -> (from NAVIGATE) paste the last yank and drop into TYPING (never runs)
"
" Paste never executes: a linewise yank carries a trailing newline, and sending
" a newline to a shell IS pressing Enter -- so we strip the trailing newline; a
" multi-line paste keeps its inner newlines but as quoted-inserts, so it lands as
" one multi-line command to review, not a run of executed lines. Deletes drop you
" into TYPING at the edit point, since the shell owns and redraws the line.

let s:count = 0

function! s:shell() abort
  return empty(&shell) ? 'sh' : &shell
endfunction

" low-level: send raw bytes straight to THIS buffer's shell job. A Vim yank can't
" be `p`-ed into a terminal (the shell owns its line) so we feed the job directly.
function! s:send(text) abort
  if empty(a:text)
    return
  endif
  if has('nvim')
    let l:job = getbufvar('%', 'terminal_job_id', 0)
    if l:job | call chansend(l:job, a:text) | endif
  else
    call term_sendkeys(bufnr('%'), a:text)
  endif
endfunction

" enter Terminal-Job (TYPING) mode. feedkeys the built-in `i` (no remap) rather
" than :startinsert -- startinsert doesn't take from inside a <Cmd> mapping, which
" would leave us in read-only Terminal-Normal and silently drop typed keys.
function! s:enter_job() abort
  call feedkeys('i', 'n')
endfunction

" paste a register into the shell WITHOUT running it. Drop CRs and the trailing
" newline (a linewise yank's newline would auto-run the command). Keep INTERNAL
" newlines but send each as a quoted-insert (Ctrl-V, LF) so a multi-line paste
" goes in literally as one multi-line command instead of executing line by line.
" (Bracketed paste isn't portable -- pre-4.4 bash echoes the markers raw AND
" still runs each line; Ctrl-V quoted-insert works on both bash and zsh.)
function! s:paste(reg) abort
  let l:text = substitute(getreg(a:reg), '\r', '', 'g')
  let l:text = substitute(l:text, '\n\+$', '', '')
  if empty(l:text)
    return
  endif
  call s:send(join(split(l:text, '\n', 1), nr2char(22) . nr2char(10)))
endfunction

function! s:paste_and_type(reg) abort
  call s:paste(a:reg)
  call s:enter_job()
endfunction

" On Esc we anchor where the shell's input cursor sits, so i/a can walk back to a
" navigated column. We store the buffer line (for a same-line check) and the
" cursor's SCREEN column. In Vim we read the true, UNCLAMPED position with
" term_getcursor() -- Vim otherwise snaps Terminal-Normal onto the last char when
" nothing is painted past the input, which a shell's right-prompt changes. Screen
" columns (not byte columns) keep this correct under a multibyte prompt like `❯`.
function! s:mark_end() abort
  if !has('nvim') && exists('*term_getcursor')
    let l:scol = term_getcursor(bufnr('%'))[1]
  else
    let l:scol = virtcol('.')
  endif
  let b:ft_shell_end = [line('.'), l:scol]
endfunction

" Screen col just past the last INPUT char on `row`. A right-side prompt sits
" after a run of 2+ spaces (commands rarely contain double spaces), so cut there;
" otherwise the last non-blank. Continuation rows have neither prompt, so this is
" just their content width.
function! s:row_input_end_vcol(row) abort
  let l:line = getline(a:row)
  let l:left = matchstr(l:line, '\v^.{-}\ze\s{2,}\S')
  if empty(l:left)
    let l:left = substitute(l:line, '\s\+$', '', '')
  endif
  return strdisplaywidth(l:left) + 1
endfunction

" Graphemes from a buffer position forward to the shell's input end (the recorded
" cursor), walking the rows of a multi-line command in between. A left-arrow
" moves one grapheme back through the whole buffer (wrapping newlines), so this
" count is exactly how many left-arrows reach the position. -1 if out of range.
function! s:chars_to_end(trow, tvcol) abort
  let l:end = get(b:, 'ft_shell_end', [])
  if len(l:end) != 2 || a:trow ># l:end[0] || a:trow <# 1
    return -1
  endif
  if a:trow ==# l:end[0]
    return l:end[1] - a:tvcol
  endif
  let l:n = s:row_input_end_vcol(a:trow) - a:tvcol + 1   " this row's tail + newline
  let l:m = a:trow + 1
  while l:m <# l:end[0]
    if empty(getline(l:m))
      return -1
    endif
    let l:n += s:row_input_end_vcol(l:m)                  " full row (col1..end) + newline
    let l:m += 1
  endwhile
  return l:n + l:end[1] - 1                               " end row: col1..end_vcol
endfunction

" Step the shell cursor left to the Vim cursor's position (crossing rows for a
" multi-line command). after=1 stops one grapheme further right (AFTER the char).
function! s:lefts_to_cursor(after) abort
  let l:n = s:chars_to_end(line('.'), virtcol('.'))
  if l:n <# 0
    return
  endif
  if a:after && l:n > 0
    let l:n -= 1
  endif
  if l:n > 0
    call s:send(repeat("\<Esc>[D", l:n))
  endif
endfunction

" i/a from NAVIGATE: reposition to the navigated column, then resume typing
" there. i lands before the char under the cursor; a one grapheme further right.
function! s:resume(kind) abort
  call s:lefts_to_cursor(a:kind ==# 'a')
  call s:enter_job()
endfunction

" Delete from NAVIGATE. The shell owns the line, so we reposition its cursor and
" fire the matching readline/zle kill, then drop into typing at the edit point
" (the shell redraws the line). Works even when the input wraps across rows.
"   x  char under cursor    dw  word forward    db  word back
"   D  to end of line       dd  the whole (even wrapped) input line
function! s:kill(what) abort
  if a:what ==# 'line'
    " Clear the WHOLE current input, even a multi-line paste: flood backspaces
    " (delete back to the input start, clamping there harmlessly) sized to the
    " contiguous block above the shell cursor. The prompt is never touched.
    let l:end = get(b:, 'ft_shell_end', [line('.'), col('.')])
    let l:count = 0
    let l:r = l:end[0]
    while l:r >=# 1 && !empty(getline(l:r)) && (l:end[0] - l:r) <# 15
      let l:count += strchars(getline(l:r)) + 1
      let l:r -= 1
    endwhile
    call s:send(repeat(nr2char(127), l:count + 4))
  else
    call s:lefts_to_cursor(0)
    if a:what ==# 'char'
      call s:send("\<Esc>[3~")        " delete-forward: the char under the cursor
    elseif a:what ==# 'wordf'
      call s:send("\<Esc>d")          " kill-word forward
    elseif a:what ==# 'wordb'
      call s:send("\<C-w>")           " kill-word backward
    elseif a:what ==# 'toend'
      call s:send("\<C-k>")           " kill to end of line
    endif
  endif
  call s:enter_job()
endfunction

" Delete a VISUAL selection (v-highlight then d/x). Park the shell cursor before
" the first selected char, then delete-forward exactly the selected grapheme
" count. Only handles a selection on the live input line; then drops into typing.
function! s:visual_delete() abort
  let l:p1 = getpos("'<")
  let l:p2 = getpos("'>")
  " clamp the end column onto a real char ('> may sit past EOL)
  let l:c2 = min([l:p2[2], max([1, len(getline(l:p2[1]))])])
  let l:sc = s:chars_to_end(l:p1[1], virtcol([l:p1[1], l:p1[2]]))
  let l:ec = s:chars_to_end(l:p2[1], virtcol([l:p2[1], l:c2]))
  if l:sc >=# 0 && l:ec >=# 0
    let l:n = l:sc - l:ec + 1              " selected graphemes (newlines included)
    if l:sc > 0
      call s:send(repeat("\<Esc>[D", l:sc))
    endif
    if l:n > 0
      call s:send(repeat("\<Esc>[3~", l:n))
    endif
  endif
  call s:enter_job()
endfunction

" modal keys, buffer-local to each terminal (tnoremap fires in window terminals)
function! s:setup_keys() abort
  tnoremap <buffer><silent> <Esc> <C-\><C-n>:call <SID>mark_end()<CR>
  tnoremap <buffer><silent> <C-v> <Cmd>call <SID>paste('"')<CR>
  nnoremap <buffer><silent> i     <Cmd>call <SID>resume('i')<CR>
  nnoremap <buffer><silent> a     <Cmd>call <SID>resume('a')<CR>
  nnoremap <buffer><silent> P     <Cmd>call <SID>paste_and_type('"')<CR>
  " Vim-ish deletes, translated to the shell's line editor
  nnoremap <buffer><silent> x     <Cmd>call <SID>kill('char')<CR>
  nnoremap <buffer><silent> D     <Cmd>call <SID>kill('toend')<CR>
  nnoremap <buffer><silent> dd    <Cmd>call <SID>kill('line')<CR>
  nnoremap <buffer><silent> dw    <Cmd>call <SID>kill('wordf')<CR>
  nnoremap <buffer><silent> db    <Cmd>call <SID>kill('wordb')<CR>
  " delete a visual highlight (:<C-u> so '<,'> are set before the call)
  xnoremap <buffer><silent> d     :<C-u>call <SID>visual_delete()<CR>
  xnoremap <buffer><silent> x     :<C-u>call <SID>visual_delete()<CR>
endfunction

" NARROW sidebar/tree filetypes a terminal must never open INTO (it would
" inherit the tree's narrow size). NOTE: startify (the full-window dashboard) is
" deliberately NOT here -- opening a terminal from the dashboard should replace
" it, exactly like opening a file does.
let s:sidebars = ['nerdtree', 'defx', 'vimfiler', 'NvimTree', 'neo-tree',
      \ 'tagbar', 'vista', 'vista_kind', 'undotree', 'Mundo', 'SpaceVimFileTree']

function! s:is_sidebar(winid) abort
  return index(s:sidebars, getbufvar(winbufnr(a:winid), '&filetype')) >= 0
endfunction

" if the current window is a narrow tree/sidebar, hop to the MAIN editing window
" (the biggest non-sidebar window) so the terminal opens like a file, full size.
function! s:goto_editable() abort
  if !s:is_sidebar(win_getid())
    return
  endif
  let l:best = 0
  let l:best_area = -1
  for l:w in range(1, winnr('$'))
    let l:id = win_getid(l:w)
    if !s:is_sidebar(l:id)
      let l:area = winwidth(l:id) * winheight(l:id)
      if l:area > l:best_area
        let l:best_area = l:area
        let l:best = l:id
      endif
    endif
  endfor
  if l:best
    call win_gotoid(l:best)
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
