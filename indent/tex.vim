" Language:            tex 

" Only load this indent file when no other was loaded.
if exists("b:did_indent")
  finish
endif
let b:did_indent = 1

" Some preliminary settings
setlocal nolisp         " Make sure lisp indenting doesn't supersede us
setlocal autoindent     " indentexpr isn't much help otherwise

setlocal indentexpr=TexIndent(v:lnum)
setlocal indentkeys=!^F,o,O,<:>,0),0],0}

function! TexIndent(lnum)
" lnum, indent, prevnonblank, and many functions start with 1, rather than 0.
" But its built-in array starts with 0.
" :let mylist = [1, 2, ['a', 'b']]
" :echo mylist[0]

python << endpython
import vim
from os import system, listdir

def get_indent(lnum):
  #print "arg:", lnum, type(lnum)
  # buffer[] startswith 0, which is of python style.
  buffer = vim.current.buffer

  line = buffer[lnum].strip()

  if lnum == 0:
    return 0
    
  prev_num = int(vim.eval("prevnonblank(%s)" %(lnum - 1 + 1))) - 1
  prev_line = buffer[prev_num].strip()
  prev_indent = int(vim.eval("indent(%s)" %(prev_num + 1)))
  #print "prev_num:", prev_num, prev_indent, prev_line
  #print "current line:", lnum, line

  if line.startswith(r"\end{") or line == "}":
    return prev_indent - 2

  if (prev_line.startswith(r"\begin") or
      prev_line.endswith("{")):
    return prev_indent + 2
  
  return prev_indent

lnum = int(vim.eval("a:lnum"))
indent = get_indent(lnum - 1)
#print "indent:", indent
vim.command("let ret = %s" %indent)
endpython

return ret
endfunction
