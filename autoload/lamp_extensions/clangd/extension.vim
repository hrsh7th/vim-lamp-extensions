"
" lamp_extensions#clangd#extension#activate
"
function! lamp_extensions#clangd#extension#activate(option) abort
  call lamp#register('clangd', {
  \   'command': ['clangd', '-background-index'],
  \   'filetypes': ['c', 'cpp', 'objc', 'objcpp'],
  \ })

  command! -nargs=1 LampSwitchSourceHeader call s:command_switch_source_header('<args>')
endfunction

"
" command_switch_source_header
"
function! s:command_switch_source_header() abort
  let l:clangd = lamp#server#registry#get_by_name('clangd')
  if empty(l:clangd)
    call lamp#view#notice#add({ 'line': ['`SwitchSourceHeader`: Clangd does not exists.'] })
    return
  endif

  if index(l:clangd.filetype, &filetype) == -1
    call lamp#view#notice#add({ 'line': ['`SwitchSourceHeader`: Filetype does not support.'] })
  endif

  let l:header = lamp#sync(
  \   l:clangd.request(
  \     'textDocument/switchSourceHeader',
  \     lamp#protocol#document#identifier(bufnr('%'))
  \   )
  \ )
  if strlen(l:header) == 0
    call lamp#view#notice#add({ 'line': ['`SwitchSourceHeader`: No header found.'] })
    return
  endif
  execute printf('edit %s', fnameescape(lamp#protocol#document#decode_uri(l:header)))
endfunction

