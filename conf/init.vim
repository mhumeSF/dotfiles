" vimrc
" Author: Mike Hume <mhumesf@gmail.com>
" Source: https://github.com/mhumesf/dotfiles
" Largely lifted from kick-ass https://github.com/zaiste/vimified

let s:dotvim = expand('$HOME/.config/nvim')

let s:backup_dir     = s:dotvim.'/tmp/backup'
let s:swap_dir       = s:dotvim.'/tmp/swap'
let s:undo_dir       = s:dotvim.'/tmp/undo'

function! s:make_dir(dir) abort
  if !isdirectory(a:dir)
    call mkdir(a:dir, 'p')
  endif
endfunction
call s:make_dir(s:backup_dir)
call s:make_dir(s:swap_dir)
call s:make_dir(s:undo_dir)

" VIM-PLUG {{{
if empty(glob("~/.config/nvim/autoload/plug.vim"))
    silent !curl -fLso ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall
end
" }}}
" PLUGINS LIST {{{
call plug#begin("~/.config/nvim/plugged/")

Plug 'morhetz/gruvbox'
Plug 'tpope/vim-git'
Plug 'tpope/vim-fugitive'
Plug 'fatih/vim-go'

Plug 'cespare/vim-toml'
Plug 'darfink/vim-plist'

Plug 'hashivim/vim-terraform'
Plug 'pedrohdz/vim-yaml-folds'

Plug 'editorconfig/editorconfig-vim'
Plug 'prettier/vim-prettier', { 'do': 'yarn install' }
Plug 'neoclide/coc.nvim', {'do': 'yarn install --frozen-lockfile'}

" For :Tabularize
Plug 'godlygeek/tabular'

Plug 'pangloss/vim-javascript'
Plug 'maxmellon/vim-jsx-pretty'

call plug#end()
" }}}
" {{{ General
colorscheme gruvbox
let mapleader = ","
let maplocalleader = "\\"
" }}}
" . folding {{{
set foldlevelstart=0
set foldmethod=syntax

" Space to toggle folds.
nnoremap <space> za
vnoremap <space> za

" Make zO recursively open whatever top level fold we're in, no matter where the
" cursor happens to be.
nnoremap zO zCzO

" Use ,z to "focus" the current fold.
nnoremap <leader>z zMzvzz

" }}}
" _ Vim {{{
augroup ft_vim
    au!

    au FileType vim setlocal foldmethod=marker
    au FileType help setlocal textwidth=78
    au BufWinEnter *.txt if &ft == 'help' | wincmd L | endif
augroup END
" }}}
" Settings {{{
set autoread
set backspace=indent,eol,start
set binary
set cinoptions=:0,(s,u0,U1,g0,t0
set completeopt=menuone,preview
set encoding=utf-8
set hidden
set history=1000
set incsearch
set laststatus=2
set list

" Don't redraw while executing macros
set nolazyredraw

" Disable the macvim toolbar
set guioptions-=T

set listchars=tab:▸\ ,eol:¬,extends:❯,precedes:❮,trail:␣
set showbreak=↪

set notimeout
set ttimeout
set ttimeoutlen=10

" sane regexes
nnoremap / /\v
vnoremap / /\v

set ignorecase
set smartcase
set showmatch
set gdefault
set hlsearch

" _ backups {{{
if has('persistent_undo')
  " undo files
  exec 'set undodir='.s:dotvim.'/tmp/undo//'
  set undofile
  set undolevels=3000
  set undoreload=10000
endif
" backups
exec 'set backupdir='.s:dotvim.'/tmp/backup//'
" swap files
exec 'set directory='.s:dotvim.'/tmp/swap//'
set backup
set noswapfile
" _ }}}

" Trailing whitespace {{{
" Only shown when not in insert mode so I don't go insane.
augroup trailing
    au!
    au InsertEnter * :set listchars-=trail:␣
    au InsertLeave * :set listchars+=trail:␣
augroup END

" Remove trailing whitespaces when saving
" Wanna know more? http://vim.wikia.com/wiki/Remove_unwanted_spaces
" If you want to remove trailing spaces when you want, so not automatically,
" see
" http://vim.wikia.com/wiki/Remove_unwanted_spaces#Display_or_remove_unwanted_whitespace_with_a_script.
autocmd BufWritePre * :%s/\s\+$//e

" }}}
"
set modelines=0
set noeol
if exists('+relativenumber')
  set relativenumber
endif
set numberwidth=3
set winwidth=83
set ruler
if executable('zsh')
  set shell=zsh\ -l
endif
set showcmd

set exrc
set secure

set matchtime=2

set completeopt=longest,menuone,preview

" White characters {{{
set autoindent
set tabstop=4
set softtabstop=4
set textwidth=80
set shiftwidth=4
set expandtab
set wrap
set formatoptions=qrn1
if exists('+colorcolumn')
  set colorcolumn=+1
endif
set cpo+=J
" }}}

set visualbell

set wildignore=.svn,CVS,.git,.hg,*.o,*.a,*.class,*.mo,*.la,*.so,*.obj,*.swp,*.jpg,*.png,*.xpm,*.gif,.DS_Store,*.aux,*.out,*.toc,tmp,*.scssc
set wildmenu

set dictionary=/usr/share/dict/words
" }}}
" TODO {{{
" - Visual selection with GreaterThan/LessThan
" - tab completion for exisiting items
" - per filetype syntax
" CSS, JS, HTML, GO, YAML, PYTHON, JAVA, PHP, RUBY,  RUST
" _. CSS {{{
" }}}
" }}}

" COC Settings
" https://github.com/neoclide/coc.nvim/tree/3bdfdd2a86046d7b0938da6e0f940ec39f999bca#example-vim-configuration
" if hidden is not set, TextEdit might fail.
set hidden

" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup

" Better display for messages
set cmdheight=2

" Smaller updatetime for CursorHold & CursorHoldI
set updatetime=300

" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[c` and `]c` to navigate diagnostics
nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
vmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
vmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)


" Add diagnostic info for https://github.com/itchyny/lightline.vim
let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'cocstatus', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'cocstatus': 'coc#status'
      \ },
      \ }



" Using CocList
" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>

""" Plist
function! s:ConvertBinaryPlist()
  silent! execute '%d'
  call plutil#Read(1)
  call plutil#ReadPost()
  set fileencoding=utf-8

  augroup BinaryPlistWrite
    autocmd! BufWriteCmd,FileWriteCmd <buffer>
    autocmd BufWriteCmd,FileWriteCmd <buffer> call plist#Write()
  augroup END
endfunction
augroup BinaryPlistRead
  autocmd!
  autocmd BufRead *
        \ if getline(1) =~# '^bplist' |
        \   call s:ConvertBinaryPlist() |
        \ endif
  autocmd BufNewFile *.plist
        \ if !get(b:, 'plist_original_format') |
        \   let b:plist_original_format = 'xml' |
        \ endif
augroup END
" Disable default autocmds
let g:loaded_plist = 1
let g:plist_display_format = 'xml'
let g:plist_save_format = ''
let g:plist_json_filetype = 'json'
