" Plugins {{{
call plug#begin('~/.local/share/nvim/plugged')

Plug 'vim-scripts/JavaDecompiler.vim'

" Completion engine
Plug 'Shougo/deoplete.nvim', {'do': ':UpdateRemotePlugins'}
" Fuzzy finding
Plug 'Shougo/denite.nvim'
" Linting engine
Plug 'w0rp/ale'
" Typescript
Plug 'HerringtonDarkholme/yats.vim'
Plug 'mhartington/nvim-typescript', {'do': './install.sh'}

Plug 'bronson/vim-trailing-whitespace'

" Visuals
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'airblade/vim-gitgutter'

Plug 'arcticicestudio/nord-vim'
Plug 'ryanoasis/vim-devicons'

call plug#end()

let g:deoplete#enable_at_startup = 1
" }}}

" Tabs {{{
set expandtab
set tabstop=4
set shiftwidth=4
" }}}

" Binds {{{

nmap <tab> <ESC>:bnext<CR>
nmap <s-tab> <ESC>:bprev<CR>

map <c-x><c-x> <ESC>:bdel<CR>
map <c-x><c-s> <ESC>:w<CR>

nmap <c-x><c-n> <ESC>:ALENextWrap<CR>
nmap <c-x><c-f> <ESC>:ALEFix<CR>
nmap <c-x><c-g> <ESC>:ALEGoToDefinition<CR>
nmap <c-x><c-i> <ESC>:ALEHover<CR>
nmap <c-x><c-b> <ESC>:ALEFindReferences<CR>

" }}}

" Auto Commands {{{

autocmd BufWritePost ~/.Xresources :silent !xrdb -merge ~/.Xresources

" }}}

" Visual {{{
" Doesn't work (well) with urxvt
" set termguicolors

set number
" highlight LineNr ctermfg=grey
"
" highlight GitGutterAdd ctermfg=green
" highlight GitGutterChange ctermfg=green
" highlight GitGutterDelete ctermfg=red
"
" highlight Pmenu ctermbg=238 ctermfg=white
" highlight PmenuSel ctermbg=240 ctermfg=white

let g:gitgutter_async = 0
set updatetime=100

colorscheme nord

" }}}

" Quality of Life {{{

" Folding
set foldmethod=marker

" Don't be stupid
set hidden
set nocompatible

" Better searching
set ignorecase
set smartcase

inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"

" }}}

" Airline {{{

let g:airline_theme = 'biogoo'
let g:airline#extensions#ale#enabled = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_buffers = 2

let g:airline_powerline_fonts = 1

" }}}

" ALE {{{

let g:ale_open_list = 0
let g:ale_lint_delay = 0
let g:ale_list_window_size = 50

let g:ale_fix_on_save = 1
let g:ale_completion_tsserver_autoimport = 1

let g:ale_sign_error = '●'
let g:ale_sign_warning = '.'

let g:ale_fixers = {
            \   '*': [
            \       'remove_trailing_lines',
            \       'trim_whitespace'
            \   ],
            \   'typescript': [
            \       'remove_trailing_lines',
            \       'trim_whitespace',
            \       'tslint'
            \   ]
            \}

" }}}

" Denite {{{

" Courtesy of: https://github.com/ctaylo21/jarvis

try
    " === Denite setup ==="
    " Use ripgrep for searching current directory for files
    " By default, ripgrep will respect rules in .gitignore
    "   --files: Print each file that would be searched (but don't search)
    "   --glob:  Include or exclues files for searching that match the given glob
    "            (aka ignore .git files)
    "
    call denite#custom#var('file/rec', 'command', ['rg', '--files', '--glob', '!.git'])

    " Use ripgrep in place of "grep"
    call denite#custom#var('grep', 'command', ['rg'])

    " Custom options for ripgrep
    "   --vimgrep:  Show results with every match on it's own line
    "   --hidden:   Search hidden directories and files
    "   --heading:  Show the file name above clusters of matches from each file
    "   --S:        Search case insensitively if the pattern is all lowercase
    call denite#custom#var('grep', 'default_opts', ['--hidden', '--vimgrep', '--heading', '-S'])

    " Recommended defaults for ripgrep via Denite docs
    call denite#custom#var('grep', 'recursive_opts', [])
    call denite#custom#var('grep', 'pattern_opt', ['--regexp'])
    call denite#custom#var('grep', 'separator', ['--'])
    call denite#custom#var('grep', 'final_opts', [])

    " Remove date from buffer list
    call denite#custom#var('buffer', 'date_format', '')

    " Custom options for Denite
    "   auto_resize             - Auto resize the Denite window height automatically.
    "   prompt                  - Customize denite prompt
    "   direction               - Specify Denite window direction as directly below current pane
    "   winminheight            - Specify min height for Denite window
    "   highlight_mode_insert   - Specify h1-CursorLine in insert mode
    "   prompt_highlight        - Specify color of prompt
    "   highlight_matched_char  - Matched characters highlight
    "   highlight_matched_range - matched range highlight
    let s:denite_options = {'default' : {
                \ 'split': 'floating',
                \ 'start_filter': 1,
                \ 'auto_resize': 1,
                \ 'source_names': 'short',
                \ 'prompt': '$ ',
                \ 'statusline': 0,
                \ 'highlight_matched_char': 'QuickFixLine',
                \ 'highlight_matched_range': 'Visual',
                \ 'highlight_window_background': 'Visual',
                \ 'highlight_filter_background': 'DiffAdd',
                \ 'winrow': 1,
                \ 'vertical_preview': 1
                \ }}

    " Loop through denite options and enable them
    function! s:profile(opts) abort
        for l:fname in keys(a:opts)
            for l:dopt in keys(a:opts[l:fname])
                call denite#custom#option(l:fname, l:dopt, a:opts[l:fname][l:dopt])
            endfor
        endfor
    endfunction

    call s:profile(s:denite_options)
catch
    echo 'Denite not installed. It should work after running :PlugInstall'
endtry

" === Denite shorcuts === "
"   ;         - Browser currently open buffers
"   <leader>t - Browse list of files in current directory
"   <leader>g - Search current directory for occurences of given term and close window if no results
"   <leader>j - Search current directory for occurences of word under cursor
nmap ; :Denite buffer<CR>
nmap <leader>t :DeniteProjectDir file/rec<CR>
nnoremap <leader>g :<C-u>Denite grep:. -no-empty<CR>
nnoremap <leader>j :<C-u>DeniteCursorWord grep:.<CR>

" Define mappings while in 'filter' mode
"   <C-o>         - Switch to normal mode inside of search results
"   <Esc>         - Exit denite window in any mode
"   <CR>          - Open currently selected file in any mode
"   <C-t>         - Open currently selected file in a new tab
"   <C-v>         - Open currently selected file a vertical split
"   <C-h>         - Open currently selected file in a horizontal split
autocmd FileType denite-filter call s:denite_filter_my_settings()
function! s:denite_filter_my_settings() abort
    call deoplete#custom#buffer_option('auto_complete', v:false)

    imap <silent><buffer> <C-o>
                \ <Plug>(denite_filter_quit)
    inoremap <silent><buffer><expr> <Esc>
                \ denite#do_map('quit')
    nnoremap <silent><buffer><expr> <Esc>
                \ denite#do_map('quit')
    inoremap <silent><buffer><expr> <CR>
                \ denite#do_map('do_action')
    inoremap <silent><buffer><expr> <C-t>
                \ denite#do_map('do_action', 'tabopen')
    inoremap <silent><buffer><expr> <C-v>
                \ denite#do_map('do_action', 'vsplit')
    inoremap <silent><buffer><expr> <C-h>
                \ denite#do_map('do_action', 'split')
endfunction

" Define mappings while in denite window
"   <CR>        - Opens currently selected file
"   q or <Esc>  - Quit Denite window
"   d           - Delete currenly selected file
"   p           - Preview currently selected file
"   <C-o> or i  - Switch to insert mode inside of filter prompt
"   <C-t>       - Open currently selected file in a new tab
"   <C-v>       - Open currently selected file a vertical split
"   <C-h>       - Open currently selected file in a horizontal split
autocmd FileType denite call s:denite_my_settings()
function! s:denite_my_settings() abort
    nnoremap <silent><buffer><expr> <CR>
                \ denite#do_map('do_action')
    nnoremap <silent><buffer><expr> q
                \ denite#do_map('quit')
    nnoremap <silent><buffer><expr> <Esc>
                \ denite#do_map('quit')
    nnoremap <silent><buffer><expr> d
                \ denite#do_map('do_action', 'delete')
    nnoremap <silent><buffer><expr> p
                \ denite#do_map('do_action', 'preview')
    nnoremap <silent><buffer><expr> i
                \ denite#do_map('open_filter_buffer')
    nnoremap <silent><buffer><expr> <C-o>
                \ denite#do_map('open_filter_buffer')
    nnoremap <silent><buffer><expr> <C-t>
                \ denite#do_map('do_action', 'tabopen')
    nnoremap <silent><buffer><expr> <C-v>
                \ denite#do_map('do_action', 'vsplit')
    nnoremap <silent><buffer><expr> <C-h>
                \ denite#do_map('do_action', 'split')
endfunction

" }}}

" nvim-typescript {{{

let g:nvim_typescript#type_info_on_hold = 0
let g:nvim_typescript#diagnostics_enable = 0

" }}}
