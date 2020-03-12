map <leader>pi :PlugInstall<CR>
map <leader>pc :PlugClean<CR>
call plug#begin('~/.vim/plugged')

Plug 'mhinz/vim-startify'

Plug 'w0ng/vim-hybrid'
set background=dark
let g:hybrid_custom_term_colors = 1
let g:hybrid_reduced_contrast = 1 " Remove this line if using the default palette.
colorscheme hybrid

Plug 'bling/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" for airline
let g:airline_powerline_fonts=1
let g:airline_theme = 'wombat'
let g:airline#extensions#tabline#enabled = 1
function! ArilineInit()
    let g:airline_section_a = airline#section#create(['mode', ' ', 'branch'])
    let g:airline_section_b = airline#section#create_left(['ffenc', 'hunks', '%F'])
    "let g:airline_section_c = airline#section#create(['filetype'])
    let g:airline_section_x = airline#section#create(['%P'])
    let g:airline_section_y = airline#section#create(['%B'])
    let g:airline_section_z = airline#section#create_right(['%l', '%c'])
endfunction
autocmd VimEnter * call ArilineInit()

" https://github.com/padde/jump.vim#installation
" jump.vim defines the following commands:
" 
" :J
" Equivalent to Autojump's j command – switch working directory. For example :J dot should take you to your ~/.dotfiles directory.
" 
" :Jc
" Equivalent to Autojump's jc command – switch working directory, limiting the search to subdirectories of the current working directory.
" 
" :Jo
" Equivalent to Autojump's jo command – open directory in system file explorer.
" 
" :Jco
" Equivalent to Autojump's jco command – open directory in system file explorer, limiting the search to subdirectories of the current working directory.
" 
" :Cd
" Replacement for Vim's built-in :cd command. Behaves exactly the same, except that this version keeps track of the directories you visit. Useful if a directory is not recognized by Autojump and you want to add it to the list of available shortcuts. Next time you use one of the above commands, Autojump will know about the new directory.
Plug 'padde/jump.vim'

Plug '907th/vim-auto-save'
"let g:auto_save = 1  " enable AutoSave on Vim startup
let g:auto_save = 0
augroup ft_markdown
    au!
    au FileType markdown let b:auto_save = 1
augroup END
" .vimrc
let g:auto_save_silent = 1  " do not display the auto-save notification
""" end

"括号和引号的自动补全和智能匹配
"按 shift-tab, 跳到补全的符号后面, 还是insert-mode
Plug 'Raimondi/delimitMate'
au FileType markdown let b:delimitMate_autoclose = 0

Plug 'Chiel92/vim-autoformat'
noremap <F3> :Autoformat<CR>
"let g:formatdef_sqlformat = '"sqlformat --keywords upper -"'
"let g:formatters_sql = ['sqlformat']
let g:formatdef_clangmarkdown  = '"astyle --style=google"'
let g:formatters_cpp = ['clang']

Plug 'dense-analysis/ale'
let g:ale_sign_error = '✗'
let g:ale_sign_warning = '⚡'

" 代码提示片段插件相关
" Track the engine.
Plug 'SirVer/ultisnips'
" Snippets are separated from the engine. Add this if you want them:
Plug 'honza/vim-snippets'
" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
"let g:UltiSnipsExpandTrigger="<c-\>"
let g:UltiSnipsExpandTrigger="<leader><tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<leader>b"


Plug 'ycm-core/YouCompleteMe'
nnoremap gd :YcmCompleter GoToDefinitionElseDeclaration<CR>
nnoremap g/ :YcmCompleter GetDoc<CR>
nnoremap gt :YcmCompleter GetType<CR>
nnoremap gr :YcmCompleter GoToReferences<CR>
" 主动唤起语法提示
"let g:ycm_key_invoke_completion = '<c-z>'
"let g:ycm_key_invoke_completion = '<leader>z'
let g:ycm_autoclose_preview_window_after_completion=0
let g:ycm_autoclose_preview_window_after_insertion=1
let g:ycm_use_clangd = 0
let g:ycm_python_interpreter_path = "/usr/local/bin/python3"
let g:ycm_python_binary_path = "/usr/local/bin/python3"

"" 自动切换输入法
"Plug 'ybian/smartim'
"" 设置默认输入法
"let g:smartim_default = 'com.apple.keylayout.ABC'
""end

Plug 'scrooloose/nerdtree'
" NERDTree 映射
" 切换文件树预览
nnoremap <leader>g :NERDTreeToggle<cr>
" 在目录树定位当前文件位置
nnoremap <leader>v :NERDTreeFind<cr>
" 显示行号
let NERDTreeShowLineNumbers=1
let NERDTreeAutoCenter=1
" 不显示项目树上额外的信息，例如帮助、提示什么的
let NERDTreeMinimalUI=1
" 是否显示隐藏文件
let NERDTreeShowHidden=1
let NERDTreeIgnore=['*\.swp$','\.git$','\.git*','\.DS_Store$','\.project$','\.vagrant$','\.idea$','\.settings$', '\node_modules$']

" 关闭vim时，如果打开的文件除了NERDTree没有其他文件时，它自动关闭，减少多次按:q!
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" 基于 nerdtree 显示 git 状态提示
Plug 'Xuyuanp/nerdtree-git-plugin'
" ==
" == NERDTree-git
" ==
let g:NERDTreeIndicatorMapCustom = {
            \ "Modified"  : "✹",
            \ "Staged"    : "✚",
            \ "Untracked" : "✭",
            \ "Renamed"   : "➜",
            \ "Unmerged"  : "═",
            \ "Deleted"   : "✖",
            \ "Dirty"     : "✗",
            \ "Clean"     : "✔︎",
            \ "Unknown"   : "?"
            \ }
" 美化 NERDTree
Plug 'ryanoasis/vim-devicons'

Plug 'majutsushi/tagbar'
nmap <leader>t :TagbarToggle<CR>


" 模糊检索插件
" Plug 'ctrlpvim/ctrlp.vim'
" let g:ctrlp_map = '<c-p>'

"Plug 'Yggdroot/LeaderF', { 'do': './install.sh' }
"" 禁用缓存
"let g:Lf_UseCache = 0
"let g:Lf_UseMemoryCache = 0

Plug 'junegunn/fzf.vim'

"https://github.com/theniceboy/nvim/blob/master/init.vim
" ===
" === FZF
" ===
set rtp+=/usr/local/opt/fzf
set rtp+=/home/linuxbrew/.linuxbrew/opt/fzf
noremap <leader>f :FZF<CR>
noremap <leader>a :Ag<CR>
noremap <leader>h :MRU<CR>
noremap <C-t> :BTags<CR>
noremap <C-l> :LinesWithPreview<CR>
noremap <leader>b :Buffers<CR>
"noremap ; :History:<CR>

autocmd! FileType fzf
autocmd  FileType fzf set laststatus=0 noruler
  \| autocmd BufLeave <buffer> set laststatus=2 ruler

command! -bang -nargs=* Buffers
  \ call fzf#vim#buffers(
  \   '',
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:0%', '?'),
  \   <bang>0)


command! -bang -nargs=* LinesWithPreview
    \ call fzf#vim#grep(
    \   'rg --with-filename --column --line-number --no-heading --color=always --smart-case . '.fnameescape(expand('%')), 1,
    \   fzf#vim#with_preview({}, 'up:50%', '?'),
    \   1)

command! -bang -nargs=* Ag
  \ call fzf#vim#ag(
  \   '',
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%', '?'),
  \   <bang>0)


command! -bang -nargs=* MRU call fzf#vim#history(fzf#vim#with_preview())

command! -bang BTags
  \ call fzf#vim#buffer_tags('', {
  \     'down': '40%',
  \     'options': '--with-nth 1 
  \                 --reverse 
  \                 --prompt "> " 
  \                 --preview-window="70%" 
  \                 --preview "
  \                     tail -n +\$(echo {3} | tr -d \";\\\"\") {2} |
  \                     head -n 16"'
  \ })



Plug 'Yggdroot/indentLine'
" 支持任意ASCII码，也可以使用特殊字符：¦, ┆, or │ ，但只在utf-8编码下有效
let g:indentLine_char='¦'
" 使indentline生效
let g:indentLine_enabled = 1
"
"Plug 'junegunn/vim-easy-align'
"" EasyAlign
"" Start interactive EasyAlign in visual mode (e.g. vipga)
"xmap ga <Plug>(EasyAlign)
"
"" Start interactive EasyAlign for a motion/text object (e.g. gaip)
"nmap ga <Plug>(EasyAlign)
"
"
"
"
"
"Plug 'easymotion/vim-easymotion'
"" plug easymotion
"nmap s <Plug>(easymotion-s2)
"
"Plug 'tpope/vim-surround'
"
"" Plug 'brooth/far.vim'
"
"Plug 'airblade/vim-gitgutter'
"set updatetime=100 " 100ms
"let g:gitgutter_max_signs = 1000
"
"Plug 'lfv89/vim-interestingwords'
"
"Plug 'tpope/vim-fugitive'
"Plug 'junegunn/gv.vim'
"
"Plug 'tpope/vim-commentary'
"
"" snips 相关
"" 代码补全
"Plug 'artur-shaik/vim-javacomplete2'
"
"

" markdown 配置

Plug 'mzlogin/vim-markdown-toc'
"创建Toc 指令 :GenTocGFM

""Plug 'dhruvasagar/vim-table-mode', { 'on': 'TableModeToggle' }
"

Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install', 'for':['markdown', 'vim-plug'] }
"let g:mkdp_browser = 'chromium'
let g:mkdp_browser = 'safari'
nmap <C-s> <Plug>MarkdownPreview
nmap <M-s> <Plug>MarkdownPreviewStop
nmap <F8> <Plug>MarkdownPreviewToggle

Plug 'joker1007/vim-markdown-quote-syntax'

Plug 'junegunn/limelight.vim'
" Color name (:help cterm-colors) or ANSI code
let g:limelight_conceal_ctermfg = 'gray'
let g:limelight_conceal_ctermfg = 240
Plug 'junegunn/goyo.vim'
let g:goyo_width = 100
nmap <Leader>l :Goyo<CR>
"进入goyo模式后自动触发limelight,退出后则关闭
autocmd! User GoyoEnter Limelight
autocmd! User GoyoLeave Limelight!
"
"Plug 'sbdchd/neoformat'
"
"
"前端相关插件
"参考：https://harttle.land/2015/11/22/vim-frontend.html
" https://harttle.land/2015/11/04/vim-ide.html
Plug 'mattn/emmet-vim'

" Initialize plugin system
call plug#end()
