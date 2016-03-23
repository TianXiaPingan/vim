""""""""""""""""""""""function definition""""""""""""""""""""""""""""""""""""""
function! GenOutline()

if !exists("b:open_fold")  
  let b:open_fold = 1
endif

python << endpython
import vim, re

open_fold = int(vim.eval("b:open_fold")) == 1
#print "open_fold:", open_fold
if not open_fold:
  vim.command("normal zE")
else:  
  buff = vim.current.buffer
  stack = []
  reg = re.compile(r"^\s*(class |def |@staticmethod)")

  for lineID, line in enumerate(buff):
    if reg.match(line) is not None:
      stack.append(lineID + 1)

  if stack != []:    
    if stack[0] != 1:
      stack = [1] + stack
    if stack[-1] != len(buff):
      stack.append(len(buff) + 1)

    for p in xrange(1, len(stack)):
      start, finish = stack[p - 1], stack[p] - 1
      if start < finish and not buff[start - 1].startswith("class"):
        vim.command(":%d, %d fold" %(start, finish))

endpython

let b:open_fold = !b:open_fold
"echo b:open_fold
endfunction

function! NewPython()
python << endpython
import vim

content = '''\
#!/usr/bin/env python
#coding: utf8

from algorithm import *

if __name__ == "__main__":
  os.system("clear")

  parser = optparse.OptionParser(usage = "cmd [optons] ..]")
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

""""""""""""""""""""""both for guivim and vim""""""""""""""""""""""""""""""""""
set softtabstop=2
set tabstop=2
set shiftwidth=2
set foldmethod=manual

"call MapCodingBracket()
inoremap {  {<CR>}<Esc>O
inoremap }   <C-R>=SuperEndMatch("}")<CR>
inoremap )   <C-R>=SuperEndMatch(")")<CR>
inoremap ]   <C-R>=SuperEndMatch("]")<CR>
inoremap "   <C-R>=SuperEndMatch('"')<CR>

map <F5>  :!./%<CR>

"debug run
nmap  <C-F5>        :Vdb continue<CR>      

"next line
nmap  <F6>          :Vdb next<CR>
"next function
nmap  <F7>          :Vdb step<CR>
"jump out of function
nmap  <F8>          :Vdb return<CR>

"continue
nmap  <C-F6>        :Vdb cont<CR>

"set a break point.
nmap  <F9>          :execute "Vdb break " . expand("%:p") . ":" . line(".")<CR><CR>
nmap  <C-F9>        :execute "Vdb clear " . expand("%:p") . ":" . line(".")<CR><CR>

"print variable.
vmap  <F10>         "gy:Vdb print <C-R>g<CR>
nmap  <F10>         :Vdb print <C-R><C-W><CR>

map <F3>            :call GenOutline()<CR>
