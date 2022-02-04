nnoremap <leader>li :RustFmt<cr>
nnoremap <leader>c :packadd YouCompleteMe
let g:jedi#completions_enabled = 0

let g:ycm_language_server =
            \ [
            \   {
            \     'name': 'rust',
            \     'cmdline': ['rust-analyzer'],
            \     'filetypes': ['rust'],
            \     'project_root_files': ['Cargo.toml']
            \   }
            \ ]
