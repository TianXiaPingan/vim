" Vim syntax file
" Language: Robot Reporter Grammer 
" Maintainer: Tian Xia
" Latest Revision: Fri May 29 15:28:03 2015

if exists("b:current_syntax")
  finish
endif

scriptencoding utf-8
setlocal iskeyword+=.

syn match Todo "[-+]\?\d\+"
syn match Todo "[-+]\?\d\+\.\d\+"
syn match Todo "[一二三四五六七八九十]"
"hi def link  Number Special

syn match Todo "减少"
syn match Todo "下降"
syn match Todo "流出"

syn match Label ":template"
syn match Label ":paragraph"
syn match Label ":if"
syn match Label ":else"
syn match Label ":random_one"
syn match Label ":random_order"
syn match Label ":sequence"
syn match Label ":title"
syn match Label ":section"
syn match Label ":chart"
syn match Label ":table"
syn match Label ":text"


let b:current_syntax = "robot_reporter_template"

