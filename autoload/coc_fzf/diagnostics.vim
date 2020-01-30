let s:prompt = 'Coc Diagnostics> '

function! coc_fzf#diagnostics#fzf_run(...) abort
  let l:current_buffer_only = a:0 ? a:1 : 0
  let l:diags = CocAction('diagnosticList')
  if !empty(l:diags)
    let expect_keys = join(keys(get(g:, 'fzf_action', s:default_action)), ',')
    let l:opts = {
          \ 'source': s:get_diagnostics(l:current_buffer_only),
          \ 'sink*': function('s:error_handler'),
          \ 'options': ['--multi','--expect='.expect_keys,
          \ '--layout=reverse-list', '--ansi', '--prompt=' . s:prompt],
          \ }
    call fzf#run(fzf#wrap(l:opts))
    call s:syntax()
  endif
endfunction

function! s:format_coc_diagnostic(item) abort
  return (has_key(a:item,'file')  ? bufname(a:item.file) : '')
        \ . ':' . a:item.lnum . ':' . a:item.col . ' '
        \ . a:item.severity . ' ' . a:item.message
endfunction

function! s:get_diagnostics(current_buffer_only) abort
  if a:current_buffer_only
    let l:diags = filter(CocAction('diagnosticList'), {key, val -> val.file ==# expand('%:p')})
  else
    let l:diags = CocAction('diagnosticList')
  endif
  return map(l:diags, 's:format_coc_diagnostic(v:val)')
endfunction

let s:default_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

function! s:action_for(key, ...)
  let default = a:0 ? a:1 : ''
  let l:Cmd = get(get(g:, 'fzf_action', s:default_action), a:key, default)
  return l:Cmd
endfunction

function! s:syntax() abort
  if has('syntax') && exists('g:syntax_on')
    syntax case ignore
    " apply syntax on everything but prompt
    exec 'syntax match CocFzfDiagnosticHeader /^\(\(\s*' . s:prompt . '\?.*\)\@!.\)*$/'
    syntax match CocFzfDiagnosticFile /^>\?\s*\S\+/ contained containedin=CocFzfDiagnosticHeader
    syntax match CocFzfDiagnosticError /\sError\s/ contained containedin=CocFzfDiagnosticHeader
    syntax match CocFzfDiagnosticWarning /\sWarning\s/ contained containedin=CocFzfDiagnosticHeader
    syntax match CocFzfDiagnosticInfo /\sInformation\s/ contained containedin=CocFzfDiagnosticHeader
    syntax match CocFzfDiagnosticHint /\sHint\s/ contained containedin=CocFzfDiagnosticHeader
    highlight default link CocFzfDiagnosticFile Comment
    highlight default link CocFzfDiagnosticError CocErrorSign
    highlight default link CocFzfDiagnosticWarning CocWarningSign
    highlight default link CocFzfDiagnosticInfo CocInfoSign
    highlight default link CocFzfDiagnosticHint CocHintSign
  endif
endfunction

function! s:error_handler(err) abort
  normal! m'
  let cmd = s:action_for(a:err[0])
  if !empty(cmd) && stridx('edit', cmd) < 0
    execute 'silent' cmd
  endif
  let l:parsed = s:parse_error(a:err[1:])
  execute 'buffer' bufnr(l:parsed["bufnr"])
  call cursor(l:parsed["linenr"], l:parsed["colnr"])
  normal! ^zvzz
endfunction

function! s:parse_error(err) abort
  let l:match = matchlist(a:err, '\v^([^:]*):(\d+):(\d+)(.*)')[1:4]
  if empty(l:match) || empty(l:match[0])
    return
  endif
  if empty(l:match[1]) && (bufnr(l:match[0]) == bufnr('%'))
    return
  endif
  let l:line_number = empty(l:match[1]) ? 1 : str2nr(l:match[1])
  let l:col_number = empty(l:match[2]) ? 1 : str2nr(l:match[2])
  let l:error_msg = l:match[3]
  return ({'bufnr' : l:match[0],'linenr' : l:line_number, 'colnr':l:col_number, 'text': l:error_msg})
endfunction