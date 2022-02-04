setlocal tabstop=4
setlocal shiftwidth=4
setlocal expandtab
setlocal autoindent
setlocal smarttab
setlocal formatoptions=croql

setlocal makeprg=python\ /Users/nikolaypisanchev/git/forms/forms/run_pylint.py\ %:p

let g:syntastic_python_checkers = []

"setlocal makeprg=pylint -s\ n\ --reports=n\ --msg-template=\"{path}:{line}:\ {msg_id}\ {symbol},\ {obj}\ {msg}\"\ %:p

"setlocal errorformat=%f:%l:\ %m
setlocal errorformat+=\\.%f:%l:\ %m

let g:jedi#popup_on_dot = 0
let g:jedi#show_call_signatures = "1"

nnoremap <leader>li :Silent black %:p:.<cr> <bar> :Silent isort -rc --settings-path=/Users/nikolaypisanchev/git/forms/.isort.cfg %:p:.<cr> <bar> :cex system('pycodestyle ' . shellescape(expand('%:p'))) <cr>

ab br breakpoint()

nnoremap <leader>t :call CopyTestString()<cr>

function! CopyTestString()
    let cursor_pos = getpos('.')
    call search('def test_', 'b')
    normal! w
    let testName = expand("<cword>")
    let file = @%
    call setpos('.', cursor_pos)
    let res="\"automation/" . file . " " . "-k " . testName . "\""
    let @*=res
    echo res
endfunction
