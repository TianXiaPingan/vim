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

call MapCodingBracket()
inoremap {  {<CR>}<Esc>O
inoremap }   <C-R>=SuperEndMatch("}")<CR>
inoremap )   <C-R>=SuperEndMatch(")")<CR>
inoremap ]   <C-R>=SuperEndMatch("]")<CR>

map <F5>  :!./%<CR>
map <F6>  :!ctags --exclude="excluded*" -R --c++-kinds=+p --fields=+iaSKlnz --extra=+q .<CR><CR>
