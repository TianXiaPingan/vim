""""""""""""""""""""""function definition""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""both for guivim and vim""""""""""""""""""""""""""""""""""
call MapCodingBracket()
inoremap {   <C-R>=SuperMatch()<CR>
inoremap }   <C-R>=SuperEndMatch("}")<CR>
inoremap )   <C-R>=SuperEndMatch(")")<CR>
inoremap ]   <C-R>=SuperEndMatch("]")<CR>

map <C-b>   :!javac %<CR>
map <F5>    :exec printf("!java %s", expand("%:t:r")) <CR>
