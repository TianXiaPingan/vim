""""""""""""""""""""""function definition""""""""""""""""""""""""""""""""""""""
function! ExtendNew()
python << endpython
import vim
import re 

line = vim.current.line
r1 =  re.match(r"^\s*(\w+)\s+\w+\s*=\s*$", line)
r2 =  re.match(r"^\s*(\w+)\[\]\s+\w+\s*=\s*$", line) 
if r1 is not None:
  ret = "new %s();" %r1.group(1)
elif r2 is not None:
  ret = "new %s[];" %r2.group(1)
else:  
  ret = "new"
vim.command("let ret = '%s'" %ret)

endpython

return ret ."\<Left>\<Left>"
endfunction
""""""""""""""""""""""both for guivim and vim""""""""""""""""""""""""""""""""""
"call MapCodingBracket()
inoremap {   <C-R>=SuperMatch()<CR>
inoremap }   <C-R>=SuperEndMatch("}")<CR>
inoremap )   <C-R>=SuperEndMatch(")")<CR>
inoremap ]   <C-R>=SuperEndMatch("]")<CR>
inoremap "   <C-R>=SuperEndMatch('"')<CR>

map <C-b>   :!javac %<CR>
map <F5>    :exec printf("!java %s", expand("%:t:r")) <CR>
map <F6>    :!ctags --exclude="excluded*" -R --c++-kinds=+p --fields=+iaSKlnz --extra=+q .<CR><CR>

inoremap print        System.out.println();<left><left>
inoremap new          <C-R>=ExtendNew()<CR>
