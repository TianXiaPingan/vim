function! GenEnumerationIndex()
python << endpython
import vim, re

reg = re.compile(r'''^((\s*)\d+)[\.\)]''')
indent_stack = [[-1, -1]]     # [indent size, idx]
buff = vim.current.buffer 

line_ID = 0
while line_ID < len(buff):
  ln = buff[line_ID]
  if ln.startswith("---") or ln.endswith("---"):
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

set tw=80
map --- O--------------------------------------------------------------------<Esc>

syn match Define "^---.*"
syn match Define ".*---$"

map <F5>        :call GenEnumerationIndex()<CR>
