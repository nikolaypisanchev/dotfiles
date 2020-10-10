setlocal tabstop=4
setlocal shiftwidth=4
setlocal expandtab
setlocal autoindent
setlocal smarttab
setlocal formatoptions=croql

setlocal makeprg=python\ /Users/nikolaypisanchev/git/forms/forms/run_pylint.py\ %:p

"setlocal makeprg=pylint -s\ n\ --reports=n\ --msg-template=\"{path}:{line}:\ {msg_id}\ {symbol},\ {obj}\ {msg}\"\ %:p

"setlocal errorformat=%f:%l:\ %m
setlocal errorformat+=\\.%f:%l:\ %m

nnoremap <leader>li :Silent black %:p<cr> <bar> :Silent isort -rc %:p<cr> <bar> :cex system('pycodestyle ' . shellescape(expand('%:p'))) <cr>

ab br breakpoint()
