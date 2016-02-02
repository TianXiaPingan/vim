""""""""""""""""""""""function definition""""""""""""""""""""""""""""""""""""""
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


