nnoremap <leader>li :RustFmt<cr>
nnoremap <leader>c :packadd YouCompleteMe

let g:ycm_language_server =
            \ [
            \   {
            \     'name': 'rust',
            \     'cmdline': ['rust-analyzer'],
            \     'filetypes': ['rust'],
            \     'project_root_files': ['Cargo.toml']
            \   }
            \ ]
