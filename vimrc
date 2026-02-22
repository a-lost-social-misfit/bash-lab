" ---------------------------------------------
" a-lost-social-misfit's vimrc
" a.lost.social.misfit@gmail.com
" License MIT
"
" Credits
"   Based on Dave Eddy's vimrc
"   https://github.com/bahamas10/dotfiles
"   https://github.com/a-lost-social-misfit/
" ---------------------------------------------
set nocompatible		" Disable VI Compatibility
set encoding=utf-8
set fileencoding=utf-8

" ---------------------------------------------
" Init - plugins
" ---------------------------------------------
call plug#begin()
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

Plug 'godlygeek/tabular'
Plug 'preservim/vim-markdown'

Plug 'rust-lang/rust.vim'
Plug 'dense-analysis/ale'

Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'

call plug#end()

" ---------------------------------------------
" Vim Options
" ---------------------------------------------
set autoindent			" Default to indenting files
set clipboard=unnamed           " For copy
set backspace=indent,eol,start	" Backspace all characters
set formatoptions-=t		" Don't add line-breaks for lines over 'textwidth' characters
set hlsearch			" Highlight search results
set number			" Enable line numbers
set relativenumber              " Relative line numbers
set nostartofline		" Do not jump to first character with page commands
set ruler			" Enable the ruler
set showmatch			" Show matching brackets.
set showmode			" Show the current mode in status line
set showcmd			" Show partial command in status line
set tabstop=8			" Number of spaces <tab> counts for
set textwidth=80		" 80 columns
set title			" Set the title

" ---------------------------------------------
" Theme / Color Scheme
" ---------------------------------------------
colorscheme default
set background=light            " Light background is best
hi Comment ctermfg=63		" Brighten up comment colors
hi Search ctermbg=LightYellow	" Search color

" ---------------------------------------------
" Abbreviations
" ---------------------------------------------
iabbrev <expr> me::
\ "# Created\n" .
\ "Author: misfit <a.lost.social.misfit@gmail.com>\n" .
\ "Date: " . strftime("%B %d, %Y") . "\n" .
\ "License: MIT\n\n" .
\ "# Contributors\n" .
\ "- misfit <a.lost.social.misfit@gmail.com>"

" ---------------------------------------------
" Aliases
" ---------------------------------------------
cmap w!! w !sudo tee > /dev/null %

" ---------------------------------------------
" File/Indenting and Syntax Highlighting
" ---------------------------------------------
if has("autocmd")
	filetype plugin indent on

	" Jump to previous cursor location, unless it's a commit message
	autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
	autocmd BufReadPost COMMIT_EDITMSG exe "normal! gg"

	" Chef/Ruby
	autocmd BufNewFile,BufRead                  *.rb setlocal filetype=ruby
	autocmd FileType                            ruby setlocal sw=2 sts=2 et

	" Yaml
	autocmd BufNewFile,BufRead                  *.yaml,*.yml setlocal filetype=yaml
	autocmd FileType                            yaml         setlocal sw=2 sts=2 et

	" JavaScript files
	autocmd BufNewFile,BufReadPre,FileReadPre   *.js        setlocal filetype=javascript
	autocmd FileType                            javascript  setlocal sw=4 sts=4 et

	" JSON files
	autocmd BufNewFile,BufReadPre,FileReadPre   *.json setlocal filetype=json
	autocmd FileType                            json   setlocal sw=2 sts=2 et

	" Objective C / C++
	autocmd BufNewFile,BufReadPre,FileReadPre   *.m    setlocal filetype=objc
	autocmd FileType                            objc   setlocal sw=4 sts=4 et
	autocmd BufNewFile,BufReadPre,FileReadPre   *.mm   setlocal filetype=objcpp
	autocmd FileType                            objcpp setlocal sw=4 sts=4 et

	" Rust files
	" autocmd BufNewFile,BufReadPre,FileReadPre   *.rs   setlocal filetype=rust
	autocmd FileType                            rust   setlocal sw=4 sts=4 et textwidth=80

	" Python files
	autocmd BufNewFile,BufReadPre,FileReadPre   *.py   setlocal filetype=python
	autocmd FileType                            python setlocal sw=4 sts=4 et

	" Markdown files
	autocmd BufNewFile,BufRead,FileReadPre      *.md,*.markdown setlocal filetype=markdown
	autocmd FileType                            markdown      setlocal sw=4 sts=4 et spell
	" Jekyll posts ignore yaml headers
	autocmd BufNewFile,BufRead                  */_posts/*.md syntax match Comment /\%^---\_.\{-}---$/
	autocmd BufNewFile,BufRead                  */_posts/*.md syntax region lqdHighlight start=/^{%\s*highlight\(\s\+\w\+\)\{0,1}\s*%}$/ end=/{%\s*endhighlight\s*%}/

	" EJS javascript templates
	autocmd BufNewFile,BufRead,FileReadPre      *.ejs setlocal filetype=html

	" TXT files
	autocmd FileType                            text setlocal spell

	" Mermaid files
	autocmd FileType                            mermaid setlocal sw=4 sts=4 et
endif

" ---------------------------------------------
" Highlight Unwanted Whitespace
" ---------------------------------------------
highlight RedundantWhitespace ctermbg=green guibg=green
match RedundantWhitespace /\s\+$\| \+\ze\t/

" ---------------------------------------------
" Spell Check Settings
" ---------------------------------------------
set spelllang=en
highlight clear SpellBad
highlight SpellBad term=standout cterm=underline ctermfg=red
highlight clear SpellCap
highlight SpellCap term=underline cterm=underline
highlight clear SpellRare
highlight SpellRare term=underline cterm=underline
highlight clear SpellLocal
highlight SpellLocal term=underline cterm=underline

" ---------------------------------------------
" Plugins
" ---------------------------------------------
let g:airline_powerline_fonts = 0
let g:airline_theme = "deus"
let g:rust_recommended_style = 1
let g:ale_linters = {
\  'bash': ['shellcheck'],
\  'sh': ['shellcheck'],
\  'c': [],
\  'rust': ['analyzer'],
\}
let g:ale_completion_enabled = 1
let g:ale_completion_enabled = 1
let g:vim_markdown_folding_disabled = 1

set omnifunc=ale#completion#OmniFunc

" ---------------------------------------------
" Source local config
" ---------------------------------------------
inoremap jk <Esc>

nnoremap <Space>e :Ex<CR>

if filereadable(expand("~/.vimrc.local"))
	source ~/.vimrc.local
endif
if filereadable(expand("~/.vimrc.indent"))
	source ~/.vimrc.indent
endif
