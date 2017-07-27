if exists("g:__POINTFREE_VIM__")
    finish
endif
let g:__POINTFREE_VIM__ = 1

if !exists("g:pointfree_options")
    let g:pointfree_options = ''
endif

let g:pointfree_buf_name = 'Pointfree'

if !exists("g:pointfree_buf_size")
    let g:pointfree_buf_size = 3
endif

" Mark a buffer as scratch
function! s:ScratchMarkBuffer()
    setlocal buftype=nofile
    " make sure buffer is deleted when view is closed
    setlocal bufhidden=wipe
    setlocal noswapfile
    setlocal buflisted
    setlocal nonumber
    setlocal statusline=%F
    setlocal nofoldenable
    setlocal foldcolumn=0
    setlocal wrap
    setlocal linebreak
    setlocal nolist
endfunction

" Return the number of visual lines in the buffer
fun! s:CountVisualLines()
    let initcursor = getpos(".")
    call cursor(1,1)
    let i = 0
    let previouspos = [-1,-1,-1,-1]
    " keep moving cursor down one visual line until it stops moving position
    while previouspos != getpos(".")
        let i += 1
        " store current cursor position BEFORE moving cursor
        let previouspos = getpos(".")
        normal! gj
    endwhile
    " restore cursor position
    call setpos(".", initcursor)
    return i
endfunction

" return -1 if no windows was open
"        >= 0 if cursor is now in the window
fun! s:PointfreeGotoWin() "{{{
    let bufnum = bufnr( g:pointfree_buf_name )
    if bufnum >= 0
        let win_num = bufwinnr( bufnum )
        " Will return negative for already deleted window
        exe win_num . "wincmd w"
        return 0
    endif
    return -1
endfunction "}}}

" Close pointfree Buffer
fun! PointfreeClose() "{{{
    let last_buffer = bufnr("%")
    if s:PointfreeGotoWin() >= 0
        close
    endif
    let win_num = bufwinnr( last_buffer )
    " Will return negative for already deleted window
    exe win_num . "wincmd w"
endfunction "}}}

" Open a scratch buffer or reuse the previous one
fun! PointfreeGet(expression) "{{{
    let last_buffer = bufnr("%")

    if s:PointfreeGotoWin() < 0
        new
        exe 'file ' . g:pointfree_buf_name
        setl modifiable
    else
        setl modifiable
        normal ggVGd
    endif

    call s:ScratchMarkBuffer()

    execute '.!pointfree ' . g:pointfree_options . ' "' . a:expression . '"'
    setl nomodifiable
    
    let size = s:CountVisualLines()

    if size > g:pointfree_buf_size
        let size = g:pointfree_buf_size
    endif

    execute 'resize ' . size

    nnoremap <silent> <buffer> q <esc>:close<cr>

endfunction "}}}


" Call PointfreeGet on the current line
fun! PointfreeLine() "{{{
    let line = getline( '.' )
    call PointfreeGet( line )
endfunction "}}}

command! -nargs=* Pointfree call PointfreeGet( '<args>' )
map <silent> pf :PointfreeLine<CR>
