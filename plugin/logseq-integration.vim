
if !has('vim9script') || v:version < 802
    finish
endif
vim9script
command! -narg=0  LogseqGraph Open_Graph() 
command! -narg=0  LogseqTODOs  LogseqTODO() 
nnoremap <leader>lq :execute '!start '  .. expand('<cWORD>')<CR>

var graph_path = ""
var dir = ""
if exists('g:graph_path')
    graph_path = g:graph_path
endif

def Open_Graph(): void
    graph_path = expand(graph_path .. 'journals')
    if !isdirectory(graph_path)
        echo "Logseq graph directory not found!"
        return
    endif
    execute 'edit' graph_path
    echo "Logseq graph opened!"
enddef

def LogseqTODO()
  var buf = bufnr('__REST_response__')
  if buf == -1
    echoerr 'Buffer "__REST_response__" not found'
    return
  endif
  var range = ":%"
  execute 'buffer ' .. buf
  setlocal modifiable
  dir = fnamemodify(graph_path, ':h:t')
  var cmd = "!jq '.[] | {content, pageName: .page.name}'"
        .. " | jq -s '.'"
        .. " | jq -c '.[]'"
        .. " | jq -r '(\"logseq://graph/" .. dir .. "?page=\"+.pageName + \"\t\" + .content)'"
  #     .. " | sort"
  execute range .. cmd
enddef

#  Copyright (C) 2025  SeveTech
