call plug#begin('~/.local/share/nvim/plugged')

Plug 'junegunn/vim-easy-align'
Plug 'aceofall/gtags.vim'
Plug 'Valloric/YouCompleteMe'
Plug 'rust-lang/rust.vim', {'for': 'rust'}
Plug 'rdnetto/YCM-Generator', { 'branch': 'stable' }
Plug 'fatih/vim-go', { 'for': 'go' }
Plug 'plasticboy/vim-markdown', {'for': 'markdown'}
Plug 'iamcco/markdown-preview.vim', {'for': 'markdown'}
Plug 'tbastos/vim-lua', {'for': 'lua'}
Plug 'Raimondi/delimitMate'
Plug 'scrooloose/nerdcommenter'
Plug 'w0rp/ale'
Plug 'davidhalter/jedi-vim', {'for': 'python'}
Plug 'morhetz/gruvbox'
Plug 'airblade/vim-gitgutter'

call plug#end()

set t_Co=256

let g:rustfmt_autosave = 1

set hidden

"打开光标所在行列位置的显示
set ruler

"状态栏显示设置
set statusline=[%F]%y%r%m%*%=[Line:%l/%L,Column:%c][%p%%]
set laststatus=2

"显示相对行号
"set relativenumber
"set number

"tags路径
set tags+=/usr/include/tags
set tags+=tags;
"set autochdir

"语法高亮
syntax on

"高亮显示搜索结果
set hls
set incsearch

set updatetime=200

"使能man.vim插件
":source $VIMRUNTIME/ftplugin/man.vim

"short cut settings
nmap <C-x>n :bnext<CR>
nmap <C-x>p :bprev<CR>
nmap <C-x>c :bdelete %<CR>
nmap <C-x>j :cn<CR>
nmap <C-x>k :cp<CR>

"map <c-h> <c-w>h
"map <c-j> <c-w>j
"map <c-k> <c-w>k
"map <c-l> <c-w>l

"快速全局缩进
nnoremap <F2> gg=G

map <leader>t= :Tab /=<CR>
map <leader>t: :Tab /:<CR>

"Golang GoImports short cut
nnoremap <F3> :GoImports<CR>
nnoremap <F4> :call CompileAndRun()<CR>

let g:go_template_autocreate = 0

func CompileAndRun()
    exec "w"
    if &filetype == 'c'
        exec "!clang % && ./a.out && rm a.out"
    elseif &filetype == 'cpp'
        exec "!clang++ % && ./a.out && rm a.out"
    elseif &filetype == 'go'
        exec "!go run %"
    elseif &filetype == 'python'
        exec "!python3 %"
    elseif &filetype == 'sh'
        exec "!sh %"
    elseif &filetype == 'lua'
        exec "!lua %"
    endif
endfunc

"缩进与tab宽度
set smartindent
set cindent
set tabstop=4
set shiftwidth=4
set expandtab

"退格键定义
set backspace=indent,eol,start

"始终保持底部行数
set scrolloff=5

"scheme setting
colorscheme gruvbox
set background=dark
set cursorline
highlight CursorLine cterm=NONE guibg=#C0C0C0

"vim-markdown setting
let g:vim_markdown_folding_disabled = 1
set nofoldenable

"ycm setting
let g:ycm_global_ycm_extra_conf = "/home/huang_zhenglin/.ycm_extra_conf.py"
let g:ycm_python_binary_path = "/usr/bin/python3"
let g:ycm_server_python_interpreter = "/usr/bin/python2"
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_confirm_extra_conf = 0
map <leader>c :YcmCompleter GoToDeclaration <CR>
map <leader>f :YcmCompleter GoToDefinition <CR>

"autocmd BufNewFile *.cpp,*.[ch] exec ":call SetTitle()"
func SetTitle()
    call setline(1, "/***********************************************")
    call append(line("."), "   > File Name:      ".expand("%"))
    call append(line(".")+1, "   > Author:         zhenglin.huang")
    call append(line(".")+2, "   > Created Time:   ".strftime("%F"))
    call append(line(".")+3, "   > Email:          zhenglin.huang@qdreamer.com")
    call append(line(".")+4, "***********************************************/")
    call append(line(".")+5, "")
    if &filetype == 'c'
        call append(line(".")+6, "#include <stdio.h>")
        call append(line(".")+7, "")
    endif
endfunc

autocmd BufNewFile *.py exec ":call InitPython()"
func InitPython()
    call setline(1, "#! /usr/bin/env python")
    call append(line("."), "# -*- coding:utf-8 -*-")
    call append(line(".")+1, "")
    call append(line(".")+2, "")
endfunc

"autocmd BufNewFile *.lua exec ":call InitLua()"
func InitLua()
    call setline(1, "#! /usr/bin/env lua")
    call append(line("."), "")
    call append(line(".")+1, "")
endfunc

autocmd BufNewFile * normal G

"scons settings
autocmd BufReadPost SConstruct,Sconstruct,sconstruct,SConscript exec ":call InitScons()"
func InitScons()
    exec ":set filetype=python"
    exec ":let g:pymode_lint = 0"
endfunc

autocmd BufWritePost *.go exec ":GoImports"

autocmd QuickFixCmdPost * vert copen 90

autocmd InsertEnter * exec ":set norelativenumber nonumber"
autocmd InsertLeave * exec ":set relativenumber number"
autocmd BufWinEnter * exec ":set relativenumber number"

func EnterTerm()
    exec ":set norelativenumber nonumber"
    exec ":setlocal statusline=%{b:term_title}"
endfunc

autocmd TermOpen * exec ":call EnterTerm()"

"gtags-vim settings
set cscopetag
set cscopeprg='gtags-cscope'
let GtagsCscope_Auto_Load = 1
let GtagsCscope_Auto_Map = 1
let GtagsCscope_Quiet = 1

"jdei-vim settings
let g:jedi#goto_command = "<C-]>"
let g:jedi#completions_enabled = 0
let g:jedi#force_py_version = 3 

"vim-easyalign settings
vmap <Enter> <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

packloadall
silent! helptags ALL
