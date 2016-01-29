"if exists("loaded_vimdebugger")
"   finish
"endif

let loaded_vimdebugger = 1
let s:connected   = 0

highlight DebugBreak guibg=darkred    guifg=white ctermbg=darkred    ctermfg=white
highlight DebugStop  guibg=darkblue   guifg=white ctermbg=darkblue   ctermfg=white

sign define breakpoint linehl=DebugBreak
sign define current    linehl=DebugStop

" Get ready for communication
function! VDBInit(fifo, pwd, type)
  if s:connected " sanity check
    echo "Already communicating with a VDB Session!"
    return
  endif

  let s:connected=1
  let s:type = a:type
  let s:fifo = a:fifo
  execute 'cd "' . a:pwd . '"'
  
  let g:loaded_vimdebugger_mappings=1
  
  if !exists(":Vdb")
    command -nargs=+ Vdb        :call VDBCommand(<q-args>, v:count)
  endif

  python import os
  silent exec 'python os.chdir("' . a:pwd . '")'
  silent exec 'python fifo = "' . s:fifo . '"'
endfunction

function! VDBClose()
  "call s:DeleteMenu()
  "redir! > .gdbvim_breakpoints
  "silent call s:DumpBreakpoints()
  "redir END
  sign unplace *
  "let s:BpSet = ""
  let s:connected=0
endfunction

function! VDBCommand(cmd, ...)
  " Ignore whitespace
  if match (a:cmd, '^\s*$') != -1
    return
  endif
  
  " Create command arguments
  let suff=""
  
  if 0 < a:0 && a:1 != 0
    let suff = " " . a:1
  endif
  
  " Send the command
  "silent exec ":redir >>" . s:fifo ."|echon \"" . a:cmd.suff . "\n\"|redir END "
  "silent exec ':!echo "' . a:cmd . suff . '" >> ' . s:fifo
  python fd = open(fifo, 'w')
  exec 'python fd.write("%s\n" % "' . a:cmd . suff . '")'
  python fd.close()
endfunction

function! VDBBreakSet(id, file, linenum)
  call VDBJumpToLine(a:linenum, a:file)
  if !bufexists(a:file)
      execute "bad ".a:file
  endif
  execute "sign unplace " . a:id
  execute "sign place   " . a:id . " name=breakpoint line=".a:linenum." file=".a:file
endfunction

function! VDBBreakClear(id, file)
  execute "sign unplace " . a:id . " file=".a:file
endfunction

function! VDBJumpToLine(line, file)
  if !bufexists(a:file)
      if !filereadable(a:file)
          return
      endif
      execute "e ".a:file
  else
      execute "b ".a:file
  endif
  let s:file=a:file
  execute a:line
  :silent! foldopen!
endfunction

function! VDBHighlightLine(line, file)
  call VDBJumpToLine(a:line, a:file)
  execute "sign unplace ". 1
  execute "sign place " .  1 ." name=current line=".a:line." file=".a:file
endfunction


