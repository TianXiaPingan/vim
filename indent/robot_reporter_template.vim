" Vim indent file
" Language:             robot_reporter_template.vim

" Only load this indent file when no other was loaded.
if exists("b:did_indent")
 finish
endif
let b:did_indent = 1

" Some preliminary settings
setlocal nolisp         " Make sure lisp indenting doesn't supersede us
setlocal autoindent     " indentexpr isn't much help otherwise

setlocal indentexpr=GetRobotReporterTemplateIndent(v:lnum)
setlocal indentkeys=!^F,o,O,<:>,0),0],0}

function! GetRobotReporterTemplateIndent(lnum)
let plnum = prevnonblank(a:lnum - 1)
"echom "current".a:lnum
"echom "last".plnum
if plnum == 0
  "echom "plnum == 0"
  return 0
endif

if getline(a:lnum) =~ "^\\s*}\s*$"
  "echom "current }"
  return indent(plnum) - 2
endif

if getline(plnum) =~ "^\\s*:template.*"
  "echom "template"
  return indent(plnum) + 2
endif

if getline(plnum) =~ "^\\s*:paragraph.*"
  "echom "para"
  return indent(plnum) + 2
endif

if getline(plnum) =~ "^\\s*:condition.*"
  "echom "condition"
  return indent(plnum) + 2
endif

if getline(plnum) =~ "^\\s*:rondom_one.*"
  "echom "random_one"
  return indent(plnum) + 2
endif

if getline(plnum) =~ "^\\s*:random_order.*"
  "echom "random_order"
  return indent(plnum) + 2
endif

if getline(plnum) =~ "^\\s*:sequence.*"
  "echom "sequence"
  return indent(plnum) + 2
endif

"echom "the same"
return indent(plnum)
endfunction
