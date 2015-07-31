"Modified date: Sun Apr 19 20:29:18 2015
"author=Summer Rain

""""""""""""""""""""""function definition""""""""""""""""""""""""""""""""""""""
function! MapFold()
  if &foldlevel == 1
    set foldlevel=32
  elseif &foldlevel == 32
    set foldlevel=1
  endif  
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
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

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
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

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! MapScrollBind()
  if &scrollbind == 1
    set noscrollbind
    echo "noscrollbind"
  else
    set scrollbind
    echo "scrollbind"
  endif
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! MapWrap()
  if &wrap == 1
    set nowrap
    echo "nowrap"
  else
    set wrap
    echo "wrap"
  endif
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! MapPaste()
  if &paste == 1
    set nopaste
    echo "nopaste"
  else
    set paste
    echo "paste"
  endif  
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! MapCodeingBracket()
python << endpython
import vim

fname = vim.current.buffer.name
if (fname.endswith(".h") or 
    fname.endswith(".cpp") or 
    fname.endswith(".c") or
    fname.endswith(".hpp") or
    fname.endswith(".java") or
    fname.endswith(".py")):
  vim.command("inoremap ( ()<Esc>i")
  vim.command("inoremap [ []<Esc>i")
  vim.command('''inoremap " ""<Esc>i''')
  vim.command("inoremap { {<CR>}<Esc>kA")

endpython
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! AddMacroDefinitionForHeader()
python << endpython
import vim
  
flag_definition = '''\
#ifndef %s
#define %s

#endif

'''

fname = vim.current.buffer.name
buffer = vim.current.buffer
if fname.endswith(".h") and len(buffer) == 1 and len(buffer[0]) == 0:
  flag = fname.split("/")[-1].replace(".", "_").upper()
  buffer[:] = (flag_definition %(flag, flag)).split("\n")
else:
  print "The .h file must be empty"

endpython
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! NewPython()
python << endpython
import vim

content = '''\
#!/usr/bin/env python
#coding: utf8

from algorithm import *

if __name__ == "__main__":
  system("clear")

  parser = OptionParser(usage = "cmd [optons] ..]")
  #parser.add_option("-q", "--quiet", action = "store_true", dest = "verbose",
                     #default = False, help = "")
  (options, args) = parser.parse_args()
'''

buffer = vim.current.buffer
buffer[:] = content.split("\n")

endpython

:w % 
:!chmod 755 %
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! NewCplusplus()
python << endpython
import vim

content = '''\
#include "rain_algorithm.0x.h"

using namespace rain;

int main() {
  cout << "Hello World" << endl;
 
  return 0;
}
'''

buffer = vim.current.buffer
buffer[:] = content.split("\n")

endpython
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! CompileLatex(pre_compile)
python << endpython
import vim

def latex_clean(fn):
  files_to_delete = ["blg", "bbl", "log", "aux", "pdf"]
  for suffix in files_to_delete:
    cmd = '''silent !rm "%s.%s"''' %(fn, suffix)
    vim.command(cmd)

file_name = vim.current.buffer.name.split("/")[-1]
if not file_name.endswith(".tex"):
  print "Does not end with .tex"
else: 
  file_name = file_name.replace(".tex", "")

  cmd0 = '''silent !pdflatex "%s"''' %file_name
  cmd1 = '''!pdflatex "%s"''' %file_name
  cmd2 = '''silent !bibtex "%s"''' %file_name
  cmd3 = '''!open "%s.pdf"''' %file_name
 
  pre_compile = vim.eval("a:pre_compile") == "1"
  latex_clean(file_name)   
  if pre_compile:
    vim.command(cmd0) 
    vim.command(cmd3)
  else:
    #vim.command(cmd0) 
    vim.command(cmd0) 
    vim.command(cmd2) 
    vim.command(cmd0) 
    vim.command(cmd0) 
    vim.command(cmd3)

endpython
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! CompileProgram(shift_pressed)
  if @% =~ '.*\.tex'
    if a:shift_pressed == 0
      :call CompileLatex(1)
    else
      :call CompileLatex(0)
    endif
  elseif @% =~ '.*\.\(h\|cpp\|hpp\)'
    if a:shift_pressed == 0
      :!_my_make.py
    else
      :!_my_make.py -c
    endif
  endif
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! ExecuteProgram()
python << endpython
import vim
from os import listdir

file_name = vim.current.buffer.name.split("/")[-1]

found = False
if file_name.endswith(".py"):
  # Do not use system() from python, whose output is messy in VIM.
  vim.command("!./%s" %file_name)
  found = True
elif (file_name.endswith(".h") or
      file_name.endswith(".cpp") or
      file_name.endswith(".hpp")):
  if "BUILD" in listdir("."):
    '''binary = "test"'''
    for ln in open("BUILD"):
      ln = ln.strip()
      if ln.startswith("binary"):
        exe_file = ln.split("=")[1].strip()[1: -1]
        vim.command("!./%s" %exe_file)
        found = True
        break

if not found:
  print "Can not find any executable file"

endpython
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" http://stackoverflow.com/questions/21073496/why-does-vim-not-obey-my-expandtab-in-python-files
" restore the tab setting overrided by some flugin.
function! SetupPython()
    " Here, you can have the final say on what is set.  So
    " fixup any settings you don't like.
  set softtabstop=2
  set tabstop=2
  set shiftwidth=2
endfunction

""""""""""""""""""""""only for guivim""""""""""""""""""""""""""""""""""""""""""
colors desert
set guifont=Monaco:h14
" chdir to current file in time, but it will influence vim and in some cases it brings inconvenience.
"set acd

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

" don't wrap a long line.
set nowrap

" replace tab with space.
set expandtab
set tabstop=2
" width of autoindent.
set shiftwidth=2

syntax on
filetype indent on
set autoindent

" highlight the text to search.
set hls
set ignorecase

" control the cursor with mouse.
set mouse=a
set nobackup

" quick save file.
map   <C-s>         :w<Enter>
imap  <C-s>         <Esc>:w<Enter>

" build
map <C-b>           :call CompileProgram(0)<CR>
map <S-b>           :call CompileProgram(1)<CR>
map <C-e>           :!<Enter>

" copy into global clipboard.
map <C-c>           "+y

" reopen the current file.
map <F2>            :e%<Enter>

" open h/cpp file
":AS
":AV
map <F3>            :A <Enter>

" window manager.
" let g:winManagerWindowLayout='TagList|FileExplorer'
let g:winManagerWindowLayout='FileExplorer|TagList'
let g:winManagerWidth=36
map <F4>            :WMToggle<cr>

map <F5>            :call ExecuteProgram()<CR>

" create ctags file.
map <F6>            :!ctags --exclude="excluded*" -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR><CR>

highlight OverLength ctermbg=darkred ctermfg=white guibg=#FFD9D9
map <F7>            :call MapMatchLongLines()<CR>

" fold a function 
map <F8>            za<CR>
" fold all functions
map <S-F8>          :call MapFold()<CR>

" wrap
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

" pydiction
"autocmd FileType python set complete+=k~/.vim/tools/pydiction

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

"set fileencodings=utf8,cp936
set fileencodings=utf8
set encoding=utf8
set termencoding=utf8

let Tlist_Show_One_File=1
let Tlist_Exit_OnlyWindow=1

let g:miniBufExplMapCTabSwitchBufs = 1

" prérequis tags
set nocp
filetype plugin on

" OmniCppComplete
let OmniCpp_NamespaceSearch = 1
let OmniCpp_GlobalScopeSearch = 1
let OmniCpp_ShowAccess = 1
let OmniCpp_MayCompleteDot = 1
let OmniCpp_MayCompleteArrow = 1
let OmniCpp_MayCompleteScope = 1
let OmniCpp_DefaultNamespaces = ["std", "_GLIBCXX_STD"]

" automatically open and close the popup menu / preview window
au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
"set completeopt=menuone,menu,longest,preview
set completeopt=menuone,menu,longest

autocmd FileType python set omnifunc=pythoncomplete#Complete

" tricks
" cmd: set scrollbind
" usage: 'vim -RO file1 file2', and scroll two windows at the same time.

command! -bar SetupPython call SetupPython()

set tags+=~/.vim/tags/cpp

au BufRead,BufNewFile *.tpt set filetype=robot_reporter_template

" Ctrl + w: jump to another windows.

call MapCodeingBracket()

set foldmethod=indent
set foldlevel=32

"toggles lines on and off.
":IndentLinesToggle 

":setlocal spell spelllang=en_us
"]s   Move to next misspelled word after the cursor.
"[s   Like "]s" but search backwards, find the misspelled word before the cursor.  
"z=   suggest correctly spelled words.

"set textwidth=80
