"=============================================================================
" banner.vim --- SpaceVim core#banner layer
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

scriptencoding utf-8
function! SpaceVim#layers#core#banner#config() abort
  let vr = g:spacevim_version
  let g:_spacevim_welcome_banners = [
        \ [
        \ '',
        \ '        _____                   __      ___           ___',
        \ '       / ____|                  \ \    / (_)         |__ \',
        \ '      | (___  _ __   __ _  ___ __\ \  / / _ _ __ ___    ) |',
        \ '       \___ \| ''_ \ / _` |/ __/ _ \ \/ / | | ''_ ` _ \  / /',
        \ '       ____) | |_) | (_| | (_|  __/\  /  | | | | | | |/ /_',
        \ '      |_____/| .__/ \__,_|\___\___| \/   |_|_| |_| |_|____|',
        \ '             | |',
        \ '             |_|',
        \ '      version : '.vr.'   ·   github.com/joshjetson/spacevim2',
        \ '',
        \ ],
        \ [
        \ '',
        \ '       ____                     __     ___           ____',
        \ '      / ___| _ __   __ _  ___ __\ \   / (_)_ __ ___ |___ \',
        \ '      \___ \| ''_ \ / _` |/ __/ _ \ \ / /| | ''_ ` _ \  __) |',
        \ '       ___) | |_) | (_| | (_|  __/\ V / | | | | | | |/ __/',
        \ '      |____/| .__/ \__,_|\___\___| \_/  |_|_| |_| |_|_____|',
        \ '            |_|',
        \ '      version : '.vr.'   ·   github.com/joshjetson/spacevim2',
        \ '',
        \ ],
        \ [
        \ '',
        \ '         _____                     _    ___          ___',
        \ '        / ___/____  ____ _________| |  / (_)___ ___ |__ \',
        \ '        \__ \/ __ \/ __ `/ ___/ _ \ | / / / __ `__ \__/ /',
        \ '       ___/ / /_/ / /_/ / /__/  __/ |/ / / / / / / / __/',
        \ '      /____/ .___/\__,_/\___/\___/|___/_/_/ /_/ /_/____/',
        \ '          /_/',
        \ '      version : '.vr.'   ·   github.com/joshjetson/spacevim2',
        \ '',
        \ ],
        \ [
        \ '',
        \ '       ___                 __   ___       ___',
        \ '      / __|_ __  __ _ __ __\ \ / (_)_ __ |_  )',
        \ '      \__ \ ''_ \/ _` / _/ -_) V /| | ''  \ / /',
        \ '      |___/ .__/\__,_\__\___|\_/ |_|_|_|_/___|',
        \ '          |_|',
        \ '      version : '.vr.'   ·   github.com/joshjetson/spacevim2',
        \ '',
        \ ],
        \ ]
endfunction

function! SpaceVim#layers#core#banner#health() abort
  call SpaceVim#layers#core#banner#config()
  return 1
endfunction

function! SpaceVim#layers#core#banner#loadable() abort

  return 1

endfunction

function! SpaceVim#layers#core#banner#plugins() abort

  return []

endfunction

" vim:set et sw=2:
