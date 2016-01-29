set tw=80
map --- O--------------------------------------------------------------------<Esc>

syn match Define "^---.*"
syn match Define ".*---$"

map <C-o>           :call OpenLink()<CR>
