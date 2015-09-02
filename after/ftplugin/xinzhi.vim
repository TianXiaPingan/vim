""""""""""""""""""""""both for guivim and vim""""""""""""""""""""""""""""""""""
if exists("b:current_syntax")
  finish
endif

let b:current_syntax = "xinzhi"
scriptencoding utf-8

" refere to syntax.txt:260
syn match Define "王老师"
syn match Define "刘力航"
syn match Define "翟少丹"
syn match Define "赵自立"
syn match Define "杨亚野"
syn match Define "夏天"
syn match Define "萨爽"

syn match Label  '^---.*$'
syn match Type   'http:[a-zA-Z./_0-9]\+'
syn match Type   'www:[a-zA-Z./_0-9]\+'

map time a------------------ <C-R>=strftime("%c")<CR><Esc>a ------------------<Esc>

set textwidth=80
