""""""""""""""""""""""function definition""""""""""""""""""""""""""""""""""""""
function! SetBreakPoint(action)

python << endpython
import vim
import re

filename = vim.eval("expand('%')")
lineID = vim.eval("line('.')")
main_class = None

while True:
  vim.command("normal [{")
  clineID = vim.eval("line('.')")
  line = vim.eval("getline('.')")
  main_class = re.findall("[ ]?class\s* (\w+)", line)
  if clineID == lineID or main_class != []:
    break

vim.current.window.cursor = (int(lineID), 0)
if main_class != []:
  action = vim.eval("a:action")
  cmd = ":call VDBCommand('%s %s:%s')" %(action, main_class[0], lineID)
  vim.command(cmd)

  if action == "stop at":
    cmd = ":call VDBBreakSet(%s, '%s', %s)" %(lineID, filename, lineID) 
    vim.command(cmd)
  elif action == "clear": 
    cmd = ":call VDBBreakClear(%s, '%s')" %(lineID, filename) 
    vim.command(cmd)

endpython
endfunction

function! CompileJar()
python << endpython
import os

class_files = os.popen("find . -iregex '.*\.class'").read().split()
path = os.getcwd()
jar_name = os.path.split(path)[1].replace(" ", "-")
cmd = '''jar cvf %s.jar %s 1>/dev/null''' %(jar_name, " ".join(class_files)) 
#print cmd
os.system(cmd)

endpython
endfunction

function! ExtendNew()
python << endpython
import vim
import re 

line = vim.current.line
r1 =  re.findall(r"([\w<> ,]+)\s+\w+\s*=", line)
r2 =  re.findall(r"([\w<> ,]+)\[\]\s+\w+\s*=", line) 
r3 =  re.findall(r"([\w<> ,]+)\[\]\[\]\s+\w+\s*=", line) 
if r1 != []: 
  ret = "new %s();" %r1[0].strip()
elif r2 != []: 
  ret = "new %s[];" %r2[0].strip()
elif r3 != []: 
  ret = "new %s[][];" %r3[0].strip()
else:  
  ret = "new"
ret = re.sub("<.*>", "<>", ret)  
vim.command("let ret = '%s'" %ret)

endpython

if ret == "new"
  return ret
else  
  return ret ."\<Left>\<Left>"
endif
endfunction
""""""""""""""""""""""both for guivim and vim""""""""""""""""""""""""""""""""""
map <F5>              <C-s><CR>:Java<CR>

"debug run
nmap  <C-F5>        :Vdb run<CR>      

"next line
nmap  <F6>          :Vdb next<CR>
"next function
nmap  <F7>          :Vdb step<CR>
"jump out of function
nmap  <F8>          :Vdb step up<CR>

"continue
nmap  <C-F6>        :Vdb cont<CR>

"set a break point.
nmap  <F9>          :call SetBreakPoint("stop at")<CR>
nmap  <C-F9>        :call SetBreakPoint("clear")<CR>

"print variable.
vmap  <F10>         "gy:Vdb print <C-R>g<CR>
nmap  <F10>         :Vdb print <C-R><C-W><CR>

"call MapCodingBracket()
inoremap {            <C-R>=SuperMatch()<CR>
inoremap }            <C-R>=SuperEndMatch("}")<CR>
inoremap )            <C-R>=SuperEndMatch(")")<CR>
inoremap ]            <C-R>=SuperEndMatch("]")<CR>
inoremap "            <C-R>=SuperEndMatch('"')<CR>

inoremap _print       System.out.println();<left><left>
inoremap _new         <C-R>=ExtendNew()<CR>
inoremap .            .<C-X><C-U>

map <Leader>jnew      :ProjectCreate . -n java<CR>
map <Leader>jo        :ProjectOpen<CR>
map <Leader>jx        :ProjectClose<CR>
map <Leader>jl        :ProjectList<CR>

map <C-]>             :JavaSearch<CR>
map <C-b>             :ProjectBuild<CR>: call CompileJar()<CR>

