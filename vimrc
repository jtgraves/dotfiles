set nomodeline " do. not. want.
set nocompatible " old vi is old.

set vb " shhhh
set number

:syntax on

if has("gui_running")
    set background=dark
	" :color zenburn
	:color solarized
	" let g:zenburn_force_dark_Background=1
    set guioptions=egmrt
else
	:color zellner
endif

set sw=4 sts=4 ts=4
:au BufEnter *.py set tw=78 ts=4 sw=4 sta et sts=4 ai
:au BufEnter *.js set sw=2 sts=2 ts=2 et
:au BufEnter *.rb set sw=2 ts=2 et ai
:au BufEnter *.yml set sw=2 ts=2 et ai
:au BufEnter *.haml set sw=2 ts=2 et ai
:au BufEnter *.html   set sw=2 sts=2 ts=2 et

:au BufEnter *.java set sw=4 sts=4 et ai
:au BufEnter *.js set sw=2 sts=2 et ai

augroup mkd
  autocmd BufRead *.mkd  set ai formatoptions=tcroqn2 comments=n:&gt;
augroup END

filetype plugin on

let python_highlight_all = 1

function! SuperCleverTab()
  if pumvisible()
    return "\<C-N>"
  endif
    if strpart(getline('.'), 0, col('.') - 1) =~ '^\s*$'
        return "\<Tab>"
    else
        if &omnifunc != ''
            return "\<C-X>\<C-O>"
        elseif &dictionary != ''
            return "\<C-K>"
        else
            return "\<C-N>"
        endif
    endif
endfunction
" inoremap <Tab> <C-R>=SuperCleverTab()<cr>
nmap <Tab> <C-R>=SuperCleverTab()<cr>

" tab navigation like ffox
nmap <S-tab> :tabprevious<cr>
nmap <C-tab> :tabnext<cr>
map <S-tab> :tabprevious<cr>
map <C-tab> :tabnext<cr>
imap <S-tab> <ESC>:tabprevious<cr>i
imap <C-tab> <ESC>:tabnext<cr>i
" nmap <C-t> :tabnew<cr>
" imap <C-t> <ESC>:tabnew<cr>

set tags+=./tags

" trailing whitespace kills puppies
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

" cscope goodness
set tags=~/.vim/tags/snoball.tags,~/.vim/tags/tornado.tags,~/.vim/tags/mogo.tags
set nocscopeverbose
cs add ~/.vim/tags/snoball.cscope
cs add ~/.vim/tags/tornado.cscope
cs add ~/.vim/tags/mogo.cscope
cs add ~/.vim/tags/python.cscope
set cscopeverbose

set cc=81
highlight ColorColumn guibg=#990000
