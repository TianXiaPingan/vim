""""""""""""""""""""""function definition""""""""""""""""""""""""""""""""""""""
function! ExtendNew()
python << endpython
import vim
import re 

line = vim.current.line
r1 =  re.findall(r"([\w<>]+)\s+\w+\s*=", line)
r2 =  re.findall(r"([\w<>]+)\[\]\s+\w+\s*=", line) 
r3 =  re.findall(r"([\w<>]+)\[\]\[\]\s+\w+\s*=", line) 
if r1 != []: 
  ret = "new %s();" %r1[0]
elif r2 != []: 
  ret = "new %s[];" %r2[0]
elif r3 != []: 
  ret = "new %s[][];" %r3[0]
else:  
  ret = "new"
vim.command("let ret = '%s'" %ret)

endpython

return ret ."\<Left>\<Left>"
endfunction
""""""""""""""""""""""both for guivim and vim""""""""""""""""""""""""""""""""""
map <F5>              <C-s><CR>:Java<CR>

"call MapCodingBracket()
inoremap {            <C-R>=SuperMatch()<CR>
inoremap }            <C-R>=SuperEndMatch("}")<CR>
inoremap )            <C-R>=SuperEndMatch(")")<CR>
inoremap ]            <C-R>=SuperEndMatch("]")<CR>
inoremap "            <C-R>=SuperEndMatch('"')<CR>

inoremap print        System.out.println();<left><left>
inoremap new          <C-R>=ExtendNew()<CR>
inoremap .            .<C-X><C-U>

map <Leader>new       :ProjectCreate . -n java<CR>
map <Leader>o         :ProjectOpen<CR>
map <Leader>x         :ProjectClose<CR>
map <Leader>l         :ProjectList<CR>
