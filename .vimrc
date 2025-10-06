" ****************** Plugin ******************

call plug#begin('~/.vim/plugged')

" Highlight copied text
Plug 'machakann/vim-highlightedyank'

" easy-motion
Plug 'easymotion/vim-easymotion'

" surround
Plug 'tpope/vim-surround'

call plug#end()

" ****************** Plugin Configuration ******************

" 设置leader键为空格
let g:mapleader = ','

" ****************** System Configuration ******************

" Vim 的默认寄存器和系统剪贴板共享
set clipboard+=unnamed

" 设置翻页滚动时的光标与边框距离
set scrolloff=5
" 设置历史操作记录数量
set history=1000

" search
set hlsearch                    " highlight searches
set incsearch                   " do incremental searching, search as you type
set ignorecase                  " ignore case when searching
set smartcase                   " no ignorecase if Uppercase char present

" tab
set expandtab                   " expand tabs to spaces
set smarttab
set shiftround
set shiftwidth=4
set tabstop=4
set softtabstop=4                " insert mode tab and backspace use 4 spaces

" indent
set autoindent smartindent

" line number
set nu
set rnu

" ****************** Key Mapping ******************

" 插入模式下 映射方向键
inoremap <C-h> <left>
inoremap <C-j> <down>
inoremap <C-k> <up>
inoremap <C-l> <right>

" 将默认的删除命令映射到黑洞寄存器
nnoremap x "_x
nnoremap X "_X
nnoremap d "_d
nnoremap D "_D
nnoremap dd "_dd
nnoremap diw "_diw

" 创建自定义的剪切命令，复制到系统剪贴板
noremap <leader>d "+d
noremap <leader>dd "+dd

" 映射行首和行尾的快捷键
" gh=go head, 映射vim中的^
nnoremap gh ^
" gl=go last，映射vim中的$
nnoremap gl $

" 将l映射为l，解决在windows的clion中，l有延迟的问题
nnoremap l l

" 将关闭标签页按钮映射
nnoremap <leader>tc :tabc<CR>
nnoremap <leader>to :tabo<CR>

" 映射移动文本快捷键
nnoremap <C-u> :m+1<CR>
nnoremap <C-i> :m-2<CR>
vnoremap <C-u> :'<,'>m+2<CR>gv
vnoremap <C-i> :'<,'>m-2<CR>gv

" ****************** IDEA keymapping ******************
nnoremap <leader>gd :action GotoDeclaration<CR>
nnoremap <leader>gtd :action GotoTypeDeclaration<CR>
nnoremap <leader>gi :action GotoImplementation<CR>
nnoremap <leader>gu :action ShowUsages<CR>
nnoremap <leader>se :action SearchEverywhere<CR>
nnoremap <leader>gc :action GotoClass<CR>
nnoremap <leader>gf :action GotoFile<CR>
nnoremap <leader>gs :action GotoSymbol<CR>
nnoremap <leader>ga :action GotoAction<CR>
nnoremap <leader>gsu :action GotoSuperMethod<CR>
nnoremap <C-,> :action Back<CR>
nnoremap <C-.> :action Forward<CR>