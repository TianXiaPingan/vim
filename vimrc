"set scrollbind!
"set wrap!
"set ignorecase!
 
" Search and replace in a visual selection.
" :'<,'>s/red/green/g

" To jump to the beginning of a C code block (while, switch, if etc).
" [{ 
" To jump to the end of a C code block (while, switch, if etc).
" ]} 

" cancel last search lightling.
" :noh

" open multi-files in vertical windows:vim file1 file2 -O2; In horizental windows: vim file1 file2 -o2

"run commands in background,
"https://github.com/MarcWeber/vim-addon-background-cmd

"In a regex expression, use ', instead of ".

"justify a paragraph.
":set formatprg=par\ -w80
":map  <C-p> {v}!par -jw80<CR>
":vmap <C-p> !par -jw80<CR>

"Debug vimscript. All messages are shown in command ":message". 
"http://inlehmansterms.net/2014/10/31/debugging-vim/
"Could show potential grammatical errors.
":12verbose call MyFunction()
"or
":call MyFunction()
"In a pure vimscript, use echom, not echo.
":echom "Hello again, world!"

":execute "normal! gg/foo\<cr>dd"
"normal excutes commands in the normal mode;
"normal! does nonrecursively.
"Both normal and normal! do not parse <CR> and other non-printable
"characters, so 'execute' is required, and use '\' to generate the
"non-printing characters we need.
"http://learnvimscriptthehardway.stevelosh.com/chapters/30.html

"To number the lines in the file. Try one of these
":%! nl -ba
":%!cat -n

"Help for help
":h visual<C-D><Tab> : obtain list of all visual help topics 
                    ": Then use tab to step through them
":h ctrl<C-D>        : list help of all control keys
":h :r               : help for :ex command
":h CTRL-R           : normal mode
":h \r               : what's \r in a regexp
":h i_CTRL-R         : help for say <C-R> in insert mode
":h c_CTRL-R         : help for say <C-R> in command mode
":h v_CTRL-V         : visual mode
":h 'ai              : help on setting option 'autoindent'

"Searching over multiple lines: \_ includes newline
"/<!--\_p\{-}-->    : search for multiple line comments
"/fred\_s*joe/i     : any whitespace including newline
"/bugs\_.*bunny     : bugs followed by bunny anywhere in file
":h \_              : help

"!sort                  " sort selected lines

"\v (very magic) reduces backslashing
"/codes\(\n\|\s\)*where " normal regexp
"/\vcodes(\n|\s)*where  " very magic

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

"把光标所在行移到窗口的顶端、中间或底部，这时就可以用到”zt“、”zz“和”zb“。
"zt zz zb

""""""""""""""""""""""function definition""""""""""""""""""""""""""""""""""""""
function! ConcelLink()
  set conceallevel=1
  syn match Content   contained "[^\[\]]*" conceal cchar=L
  syn match Define    "\[\[.\{-}]]" contains=Content
  hi conceal ctermfg=Blue ctermbg=none guifg=Blue guibg=none
endfunction

function! OpenLink()
python << endpython
import vim, os

line, pos = vim.eval("getline('.')"), int(vim.eval("getpos('.')[2]")) - 1
f, t = line.rfind("[[", 0, pos), line.find("]]", pos)
if f != -1 and t != -1:
  addr = line[f + 2: t]
  addr = addr.replace(" ", '''\ ''')\
             .replace("'", "\\'")\
             .replace("(", "\\(")\
             .replace(")", "\\)")
  os.system("open %s" %addr)
else:
  print "Does not find a link"

endpython
endfunction

function! TextJustification() range

let start = getpos("'<")[1] - 1
let   end = getpos("'>")[1] - 1

python << endpython
import vim, os

def is_english(string):
  string = string.strip()[: 80]
  if string == "":
    return True
  chrs = [ch for ch in string if ord(ch) < 128]
  #print "ratio:", len(chrs) / float(len(string))
  return len(chrs) / float(len(string)) > 0.95

def full_justify(words, maxWidth):
  buff, words_length = [], 0
  ret, p = [], 0
  while p < len(words):
    w = words[p]
    if words_length + len(w) + len(buff) <= maxWidth:
      buff.append(w)
      if p == len(words) - 1:
        ret.append(" ".join(buff))
      else:
        words_length += len(w)
      p += 1
    elif buff == []:
      assert words_length == 0
      ret.append(w)
      p += 1
    else:
      if len(buff) == 1:
        ret.append(buff[0].rjust(maxWidth))
      else:
        blank = (maxWidth - words_length) / (len(buff) - 1)
        mod = maxWidth - words_length - blank * (len(buff) - 1)
        ret.append((" " * (blank + 1)).join(buff[: mod + 1]) +
                   " " * blank + (" " * blank).join(buff[mod + 1:]))
      buff = []
      words_length = 0

  return ret

start, end = int(vim.eval("start")), int(vim.eval("end"))
lines = vim.current.buffer[start: end + 1]
indent = len(lines[0]) - len(lines[0].lstrip())
words = " ".join(lines)
tw = int(vim.eval("&tw"))
if is_english(words) and tw != 0:
  new_lines = full_justify(words.split(), tw - indent)
  new_lines = [" " * indent + line for line in new_lines]
  vim.current.buffer[start: end + 1] = new_lines

endpython
endfunction

function! MyRename(cur_word, new_word)
  let b:case_status = &ignorecase
  if b:case_status
    set noignorecase
  endif  

  exec printf('%%s/\<%s\>/%s/g', a:cur_word, a:new_word)

  if b:case_status
    set ignorecase
  endif 
endfunction

function! QuickRename()
  let b:cur_word = expand("<cword>")
  let b:new_word = input("input: ")
  call MyRename(b:cur_word, b:new_word)
 
endfunction

function! QuickJavaRename()
  let b:new_word = input("input: ")
  exec printf('JavaRename %s', b:new_word)
 
endfunction

function! SuperMatch()
  if getline(".") =~ '\v(else|\)|try|do)'
    return "{\<CR>}\<Esc>O"
  elseif getline(".") =~ '\v(class|\=)'
    return "{\<CR>};\<Esc>O"
  else  
    return "{}\<Left>" 
  endif
endfunction

function! SuperEndMatch(bracket)
  if getline(".")[col(".") - 1] == a:bracket
    return "\<Right>"
  else
    return a:bracket
  end
endfunction

function! MapCodingBracket()
  inoremap (  ()<Left>
  inoremap [  []<Left>
  inoremap "  ""<Left>
  "inoremap {  {<CR>}<Esc>O
endfunction

function! LoadExtraVimrc()
if !has("python")
  echom "This version does not support python."
  return 
endif

python << endpython
import vim, os

fname = vim.current.buffer.name
if "/" not in fname:
  vimrc = ".%s.vimrc" %fname 
else:
  toks = fname.split("/") 
  vimrc = "/".join(toks[: -1]) + "/.%s.vimrc" %toks[-1]

#print "vimrc:", vimrc
if os.path.exists(vimrc):
  for cmd in open(vimrc):
    cmd = cmd.strip()
    #print "executing", cmd
    vim.command(cmd)

endpython
endfunction

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

function! MatchLongLines()
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
au BufRead,BufNewFile *.en set filetype=english
au BufRead,BufNewFile * call LoadExtraVimrc() 
au FileType call MapCodingBracket() 

set autoindent

set hlsearch
set ignorecase

" control the cursor with mouse.
set mouse=a
set mousetime=2000
set nobackup

map <Leader>o      :call OpenLink()<CR>

map <Leader>f       :call TextJustification()<CR>

" format a paragraph by textwidth, mainly for Chinese.
map <Leader>p       gqq

map <Leader>r       :call QuickRename()<CR>

map <Leader>gs      :!clear && git status<CR>
map <Leader>gl      :!clear && git log<CR>
map <Leader>gb      :!clear && git branch<CR>

" quick save file.
map   <C-s>         :w<CR>
imap  <C-s>         <Esc><C-s>gi

" Read console information.
map <C-e>           :!<CR>

map <C-q>           :q<CR>
map <C-x>           :x<CR>

" copy into global clipboard.
nmap     <silent> <C-c>   :call setreg("+", expand("<cword>"), "v") <CR>
vnoremap <silent> <C-c>   :normal gv"+y<CR>

nmap    <silent> <S-l>    <C-c> :exec "!open dict://" . expand("<cword>")<CR><CR>

map <C-l>           "+yy

" reopen the current file.
map <F2>            :e%<CR>

map <F3>            :A <CR>

" window manager.
let g:winManagerWindowLayout='FileExplorer|TagList'
let g:winManagerWidth=36
map <F4>            :WMToggle<CR>

"<F5> - <F10> is kept for debugging interfaces.

" fold all functions
map <F11>            :call MapFold()<CR>
" fold a function 
map <C-F11>          za<CR>

" Indent when the cursor is at the beginning '{' of a block.
map <F12>           =%

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

" what is the encoding of the file to read.
" If the file is of gbk, just 'set fileencodings=gbk' and 'F2'.
set fileencodings=utf8
" which encoding to denote the buffer in the memory.
set encoding=utf8
" how to display in the terminal.
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
let g:jedi#rename_command = "<leader>R"

let g:VIMHOME = expand('<sfile>:p:h')

highlight OverLength ctermbg=darkred ctermfg=white guibg=#FFD9D9
