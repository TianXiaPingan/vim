""""""""""""""""""""""some tricks""""""""""""""""""""""""""""""""""""""""""""""
":setlocal spell spelllang=en_us
"]s   Move to next misspelled word after the cursor.
"[s   Like "]s" but search backwards, find the misspelled word before the cursor.  
"z=   suggest correctly spelled words.

" Ctrl + w: jump to another windows.

" cmd: set scrollbind
" usage: 'vim -RO file1 file2', and scroll two windows at the same time.

"x delete
"J join two lines quickly.
"o insert a new line after current line.

"complex repeat
"1. In normal mode, qa
"2. do something...
"3. In normal mode, q.
"4. @a or 1000@@

"Open file in a binary form
"vim -b datafile
":%!xxd
":%!xxd -r

"Non-greedy .*? in vim regex. Use .\{-} instead.
"help non-greedy

"Make terminal colorful.
"add "export CLICOLOR=1 export LSCOLORS=ExFxCxDxBxegedabagacad" into ~/.profile

":scriptnames
":TOhtml

"Count current file.
"g CTRL-G

":iabbrev JB Jack Benny

"v4jgq
"v" to start Visual mode, "4j' to move to the end of the paragraph and then
"the "gq" operator.  

"gqap
"A very useful text object to use with "gq" is the paragraph.  Try this: >
" "ap" stands for "a-paragraph".  This formats the text of one paragraph
" (separated by empty lines).  Also the part before the cursor.
" For Chinese
":set formatoptions+=m 

":args *.c
":argdo %s/\<x_cnt\>/x_counter/ge | update
"Put all the relevant files in the argument list: >
"This finds all C files and edits the first one.  Now you can perform a
"substitution command on all these files: >

"/19[0-9][0-9]\|20[0-9][0-9]
"Using the same text as above, search for a year: 
"Now press CTRL-A.  The year will be increased by one.

"把光标所在行移动窗口的顶端、中间或底部，这时就可以用到”zt“、”zz“和”zb“。
"zt zz zb

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
    echo "spell check"
    :setlocal spell spelllang=en_us
    let b:spell_check = 0
  else
    echo "close spell check"
    :setlocal spell spelllang=
    let b:spell_check = 1
  endif  
endfunction

function! MapMatchLongLines()
  if !exists("b:long_lines_matched")
    let b:long_lines_matched = 0
  endif

  if b:long_lines_matched == 0
    echo "match long lines"
    :match OverLength /\%81v.\+/
    let b:long_lines_matched = 1
  elseif b:long_lines_matched == 1
    echo "close match long lines"
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
"This stops the search at the end of the file
"set nowrapscan
set incsearch
" open fold for whole word.
set lbr

set foldmethod=indent
set foldlevel=32

set nowrap

set expandtab
set tabstop=2
set shiftwidth=2
set shiftround

" For Chinese and textwidth
set formatoptions+=m
"set textwidth=80

syntax on
filetype indent on
filetype plugin on
au BufRead,BufNewFile *.tpt set filetype=robot_reporter_template
au BufRead,BufNewFile *.xinzhi set filetype=xinzhi
au BufRead,BufNewFile *.en set filetype=english

set autoindent

set hlsearch
set ignorecase

" control the cursor with mouse.
set mouse=a
set nobackup

" format a paragraph by textwidth
map <Leader>p       gqap

" quick save file.
map   <C-s>         :w<CR>
imap  <C-s>         <Esc><C-s>gi

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

" Have to define here, not in after/ftplugin/python.vim.
let g:jedi#goto_command = "<C-]>"
let g:jedi#usages_command = "<C-u>"
let g:jedi#rename_command = "<leader>r"

let g:VIMHOME = expand('<sfile>:p:h')
