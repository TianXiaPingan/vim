""""""""""""""""""""""some tricks""""""""""""""""""""""""""""""""""""""""""""""
":setlocal spell spelllang=en_us
"]s   Move to next misspelled word after the cursor.
"[s   Like "]s" but search backwards, find the misspelled word before the cursor.  
"z=   suggest correctly spelled words.

" Ctrl + w: jump to another windows.

" cmd: set scrollbind
" usage: 'vim -RO file1 file2', and scroll two windows at the same time.

""""""""""""""""""""""function definition""""""""""""""""""""""""""""""""""""""
function! MapFold()
  if &foldlevel == 1
    set foldlevel=32
  elseif &foldlevel == 32
    set foldlevel=1
  endif  
endfunction

function! SpellCheck()
  if !exists("b:spell_check")
    let b:spell_check = 1
  endif

  if b:spell_check == 1
    :setlocal spell spelllang=en_us
    let b:spell_check = 0
  else
    :setlocal spell spelllang=
    let b:spell_check = 1
  endif  
endfunction

function! MapMatchLongLines()
  if !exists("b:long_lines_matched")
    let b:long_lines_matched = 0
  endif

  if b:long_lines_matched == 0
    :match OverLength /\%81v.\+/
    let b:long_lines_matched = 1
  elseif b:long_lines_matched == 1
    :match OverLength /\%1000000081v.\+/
    let b:long_lines_matched = 0
  endif

endfunction

function! MapScrollBind()
  if &scrollbind == 1
    set noscrollbind
    echo "noscrollbind"
  else
    set scrollbind
    echo "scrollbind"
  endif
endfunction

function! MapWrap()
  if &wrap == 1
    set nowrap
    echo "nowrap"
  else
    set wrap
    echo "wrap"
  endif
endfunction

function! MapPaste()
  if &paste == 1
    set nopaste
    echo "nopaste"
  else
    set paste
    echo "paste"
  endif  
endfunction

""""""""""""""""""""""only for guivim""""""""""""""""""""""""""""""""""""""""""
colors desert
set guifont=Monaco:h14

""""""""""""""""""""""both for guivim and vim""""""""""""""""""""""""""""""""""
set showcmd
set backspace=indent,eol,start
" shut down tips sound.
set vb t_tb=
set nocompatible
set nu
set history=1000
set showmatch
set guioptions-=T
set ruler
set nohls
set cindent
set incsearch
" open fold for whole word.
set lbr

set foldmethod=indent
set foldlevel=32

set nowrap

set expandtab
set tabstop=2
set shiftwidth=2

syntax on
filetype indent on
filetype plugin on
au BufRead,BufNewFile *.tpt set filetype=robot_reporter_template

set autoindent

set hlsearch
set ignorecase

" control the cursor with mouse.
set mouse=a
set nobackup

" quick save file.
map   <C-s>         :w<Enter>
imap  <C-s>         <Esc>:w<Enter>

" Read console information.
map <C-e>           :!<Enter>

" copy into global clipboard.
map <C-c>           "+y

" reopen the current file.
map <F2>            :e%<Enter>

map <F3>            :A <Enter>

" window manager.
let g:winManagerWindowLayout='FileExplorer|TagList'
let g:winManagerWidth=36
map <F4>            :WMToggle<cr>

highlight OverLength ctermbg=darkred ctermfg=white guibg=#FFD9D9
map <F7>            :call MapMatchLongLines()<CR>

" fold all functions
map <F8>            :call MapFold()<CR>
" fold a function 
map <C-F8>          za<CR>

map <F9>            :call MapWrap()<CR>

map <F10>           :call MapScrollBind()<CR>

map <F11>           :call MapPaste()<CR>

" Indent when the cursor is at the beginning '{' of a block.
map <F12>           =%

" Remove trailing blanks.
map f0              :%s/\s\+\n/\r/g<Enter>

" insert locale time
map time            a<C-R>=strftime("%c")<CR><Esc>a

" comment and uncomment a variety of source files.
map c               <leader>c<space>

" continus paste
xnoremap p          pgvy

" Search for selected text, forwards or backwards.
vnoremap <silent> * :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy/<C-R><C-R>=substitute(
  \escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>
vnoremap <silent> # :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy?<C-R><C-R>=substitute(
  \escape(@", '?\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>

set fileencodings=utf8
set encoding=utf8
set termencoding=utf8

let Tlist_Show_One_File=1
let Tlist_Exit_OnlyWindow=1

let g:miniBufExplMapCTabSwitchBufs = 1

" automatically open and close the popup menu / preview window
au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
set completeopt=menuone,menu,longest

set tags+=~/.vim/tags/cpp

execute pathogen#infect() 
:Helptags

let g:VIMHOME = expand('<sfile>:p:h')
