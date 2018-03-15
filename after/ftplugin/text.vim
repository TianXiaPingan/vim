function! GenOutline()

if !exists("b:open_fold")  
  let b:open_fold = 1
endif

python << endpython
import vim, re

open_fold = int(vim.eval("b:open_fold")) == 1
#print "open_fold:", open_fold
if not open_fold:
  vim.command("normal zE")
else:  
  buff = vim.current.buffer
  stack = []
  reg = re.compile(r"^(\d+\.|---|!\.)")

  for lineID, line in enumerate(buff):
    if reg.match(line) is not None:
      stack.append(lineID + 1)

  if stack != []:    
    if stack[0] != 1:
      stack = [1] + stack
    if stack[-1] != len(buff):
      stack.append(len(buff) + 1)

    for p in xrange(1, len(stack)):
      vim.command(":%d, %d fold" %(stack[p - 1], stack[p] - 1))

endpython

let b:open_fold = !b:open_fold
"echo b:open_fold
endfunction

function! GenEnumerationIndex()
python << endpython
import vim, re

reg = re.compile(r'''^((\s*)\d+)[\.\)]''')
indent_stack = [[-1, -1]]     # [indent size, idx]
buff = vim.current.buffer 

line_ID = 0
while line_ID < len(buff):
  ln = buff[line_ID]
  if ln.startswith("---") or ln.endswith("---") or ln.startswith("!."):
    indent_stack = [[-1, -1]]
    line_ID += 1
    continue

  match = reg.findall(ln)
  if match == []:
    line_ID += 1
  else:
    match = match[0]
    ind_size = len(match[1])
    if ind_size < indent_stack[-1][0]:
      indent_stack.pop()
      continue

    if ind_size > indent_stack[-1][0]:
      indent_stack.append([ind_size, 1])
    else:
      indent_stack[-1][1] += 1

    nstr = " " * indent_stack[-1][0] + str(indent_stack[-1][1])
    buff[line_ID] = ln.replace(match[0], nstr)
    line_ID += 1

endpython
endfunction

set foldmethod=manual
set tw=0
set wrap
map --- O--------------------------------------------------------------------<Esc>

syn match Define          "^---.*"
syn match Define          ".*---$"
syn match String          "^\d\+\..*"
syn match String          "^!\..*"

map <F3>        :call GenOutline()<CR>
map <F5>        :call GenEnumerationIndex()<CR>

call ConcelLink() 
