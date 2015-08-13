"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! LoadTemplateVar(keyword)

let pattern = strpart(a:keyword, 0, strlen(a:keyword) - 1) . '(:\d+)?$'
let pattern = escape(pattern, '$(+)?.')

python << endpython
import vim

pattern = vim.eval("pattern")
cmd = "syn match Define '%s'" %pattern
vim.command(cmd)

endpython
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! LoadAllTemplateVar()
python << endpython
import vim

try:
  VIMHOME = vim.eval("g:VIMHOME")
  fname = "%s/data/robot_reporter_template_variables.tpt" %VIMHOME
  variables = open(fname).read().split()
  for v in variables:
    vim.command('''call LoadTemplateVar("%s")''' %v)
except IOError:
  print "Can not find '%s'" %fname

endpython
endfunction  

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"call LoadTemplateVar("$ChartLabel$")
call LoadAllTemplateVar()
