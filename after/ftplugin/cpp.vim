""""""""""""""""""""""function definition""""""""""""""""""""""""""""""""""""""
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

function! NewCplusplus()
python << endpython
import vim

content = '''\
#include "rain_algorithm.h"

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

function! ExecuteCplusplusProgram()
python << endpython
import vim
from os import listdir

found = False
if "BUILD" not in listdir("."):
  print "Not BUILD found"
else:
  '''binary = "test"'''
  for ln in open("BUILD"):
    ln = ln.strip()
    if ln.startswith("binary"):
      exe_file = ln.split("=")[1].strip()[1: -1]
      vim.command("silent !clear")
      vim.command("!./%s" %exe_file)
      break
  else:     
    print "Can not find any executable file"

endpython
endfunction

""""""""""""""""""""""both for guivim and vim""""""""""""""""""""""""""""""""""
" OmniCppComplete
let OmniCpp_NamespaceSearch = 1
let OmniCpp_GlobalScopeSearch = 1
let OmniCpp_ShowAccess = 1
let OmniCpp_MayCompleteDot = 1
let OmniCpp_MayCompleteArrow = 1
let OmniCpp_MayCompleteScope = 1
let OmniCpp_DefaultNamespaces = ["std", "_GLIBCXX_STD"]

call omni#cpp#complete#Init()

"call MapCodingBracket()
inoremap {   <C-R>=SuperMatch()<CR>
inoremap }   <C-R>=SuperEndMatch("}")<CR>
inoremap )   <C-R>=SuperEndMatch(")")<CR>
inoremap ]   <C-R>=SuperEndMatch("]")<CR>
inoremap "   <C-R>=SuperEndMatch('"')<CR>

map <C-b>         :!_my_make.py<CR>
map <C-b><C-c>    :!_my_make.py -c<CR>

map <C-F2>        :!ctags --exclude="excluded*" -R --c++-kinds=+defgpstux --fields=+iaSKlnz --extra=+q .<CR><CR>

map <F5>          :call ExecuteCplusplusProgram()<CR>

"debug run
nmap  <C-F5>        :Vdb run<CR>:Vdb where<CR>      

"next line
nmap  <F6>          :Vdb next<CR>:Vdb where<CR>
"next function
nmap  <F7>          :Vdb step<CR>:Vdb where<CR>
"jump out of function
nmap  <F8>          :Vdb finish<CR>:Vdb where<CR>

"continue
nmap  <C-F6>        :Vdb c<CR>

"set a break point.
nmap  <F9>          :execute "Vdb break " . @% . ":" . line(".")<CR>:call VDBBreakSet(line("."), @%, line("."))<CR>
nmap  <C-F9>        :execute "Vdb clear " . expand("%:p") . ":" . line(".")<CR>:call VDBBreakClear(line("."), @%)<CR>

"print variable.
vmap  <F10>         "gy:Vdb print <C-R>g<CR>
nmap  <F10>         :Vdb print <C-R><C-W><CR>


