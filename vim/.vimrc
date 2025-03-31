" Enable syntax highlighting
syntax on

" Set line numbers
set number
set relativenumber

" Set tab behavior
set expandtab       " Use spaces instead of tabs
set tabstop=4       " 1 tab = 4 spaces
set shiftwidth=4    " Auto-indent uses 4 spaces
set softtabstop=4   " Backspace deletes 4 spaces

" Enable auto-indentation
set autoindent
set smartindent

" Improve search behavior
set ignorecase      " Case insensitive search
set smartcase       " Case sensitive if uppercase used
set incsearch       " Highlight matches as you type
set hlsearch        " Highlight all search matches

" Faster UI updates
set updatetime=300

" Show matching brackets
set showmatch

" Better command-line completion
set wildmenu
set wildmode=list:longest


" Show status line always
set laststatus=2

" Use system clipboard if available
if has("clipboard")
    set clipboard=unnamedplus
endif

" Enable file type detection
filetype plugin indent on

" Set a useful leader key
let mapleader=" "

" Easier window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Highlight yanked area
"let g:highlightedyank_highlight_duration = 500
"augroup highlightYankedText
"    autocmd!
"    autocmd TextYankPost * call FlashYankedText()
"augroup END
"function! FlashYankedText()
"    if (!exists('g:yankedTextMatches'))
"        let g:yankedTextMatches = []
"    endif
"
"    let matchId = matchadd('IncSearch', ".\\%>'\\[\\_.*\\%<']..")
"    let windowId = winnr()
"
"    call add(g:yankedTextMatches, [windowId, matchId])
"    call timer_start(500, 'DeleteTemporaryMatch')
"endfunction
"
"function! DeleteTemporaryMatch(timerId)
"    while !empty(g:yankedTextMatches)
"        let match = remove(g:yankedTextMatches, 0)
"        let windowID = match[0]
"        let matchID = match[1]
"
"        try
"            call matchdelete(matchID, windowID)
"        endtry
"    endwhile
"endfunction
