""""""""""""""""""""""function definition""""""""""""""""""""""""""""""""""""""
function! LoadWord(phrase)
python << endpython
import vim

phrase = vim.eval("a:phrase").split()
phrase = ["\<%s\>" %w for w in phrase]
reg = "\_s\+".join(phrase)
if reg == "":
  exit()
vim.command('''syn match Tag "%s"''' %reg)

endpython
endfunction

function! SaveWord(phrase)
python << endpython
import vim

phrase = vim.eval("a:phrase")
VIMHOME = vim.eval("g:VIMHOME")
print >> open("%s/data/vocabulary.dat" %VIMHOME, "a"), phrase

endpython
endfunction

function! Emphasize()
normal gvy
let phrase = getreg('"')

python << endpython
import vim

phrase = " ".join(vim.eval("phrase").lower().split())
vim.command('''call SaveWord("%s")''' %phrase)
vim.command('''call LoadWord("%s")''' %phrase)

endpython
endfunction

function! LoadAllWords()
python << endpython
import vim

try:
  VIMHOME = vim.eval("g:VIMHOME")
  fname = "%s/data/vocabulary.dat" %VIMHOME
  phrases = set(open(fname).readlines())
  for v in phrases:
    vim.command('''call LoadWord("%s")''' %v)
except IOError:
  print "Can not find '%s'" %fname

endpython
endfunction 

function! ExpandandEmphrasize()
  let word = expand("<cword>")
  call LoadWord(word)
  call SaveWord(word)
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if exists("b:current_syntax")
  finish
endif

let b:current_syntax = "english"
scriptencoding utf-8
set textwidth=80

" refere to syntax.txt:260
syn case ignore

syn match Type "sent:"
syn match Type "dict:"

syn match Constant "\<adj\."
syn match Constant "\<adv\."
syn match Constant "\<n\."
syn match Constant "\<vt\."
syn match Constant "\<vi\."
syn match Constant "\<v\."

syn match Constant "/\_.\{-}/"
syn match Constant "\[\_.\{-}\]"

map <leader>s   <Esc>Isent: <Esc>
map <leader>d   <Esc>Idict: <Esc>
map <Leader>p       gqq

map @           :call ExpandandEmphrasize()<Esc>

"vnoremap <silent> @ :<C-U> normal gvy<CR> :echo getreg('"')<CR>
vnoremap <silent> @ :call Emphasize()<CR>

call LoadAllWords()
