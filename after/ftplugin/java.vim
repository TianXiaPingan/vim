""""""""""""""""""""""function definition""""""""""""""""""""""""""""""""""""""
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
nmap  <F9>          :execute "Vdb stop at " . substitute(bufname("%"), ".java", "", "") . ":" . line(".")<CR><CR>
nmap  <C-F9>        :execute "Vdb clear " . substitute(bufname("%"), ".java", "", "") . ":" . line(".")<CR><CR>

"print variable.
vmap  <F10>         "gy:Vdb print <C-R>g<CR>
nmap  <F10>         :Vdb print <C-R><C-W><CR>

"call MapCodingBracket()
inoremap {            <C-R>=SuperMatch()<CR>
inoremap }            <C-R>=SuperEndMatch("}")<CR>
inoremap )            <C-R>=SuperEndMatch(")")<CR>
inoremap ]            <C-R>=SuperEndMatch("]")<CR>
inoremap "            <C-R>=SuperEndMatch('"')<CR>

inoremap print        System.out.println();<left><left>
inoremap new          <C-R>=ExtendNew()<CR>
inoremap .            .<C-X><C-U>

map <Leader>jnew      :ProjectCreate . -n java<CR>
map <Leader>jo        :ProjectOpen<CR>
map <Leader>jx        :ProjectClose<CR>
map <Leader>jl        :ProjectList<CR>

map <C-]>             :JavaSearch<CR>
map <C-b>             :ProjectBuild<CR>

