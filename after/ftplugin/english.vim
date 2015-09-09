""""""""""""""""""""""function definition""""""""""""""""""""""""""""""""""""""
if exists("b:current_syntax")
  finish
endif

let b:current_syntax = "english"
scriptencoding utf-8
set textwidth=80

" refere to syntax.txt:260
syn case ignore

syn match Type "sent:"
syn match Type "dict:"

map <leader>s   <Esc>Isent: <Esc>
map <leader>d   <Esc>Idict: <Esc>
