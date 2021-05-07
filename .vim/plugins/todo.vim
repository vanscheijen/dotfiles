" File:        todo.txt.vim
" Description: Todo.txt filetype detection
" Author:      Leandro Freitas <freitass@gmail.com>
" License:     Vim license
" Website:     http://github.com/freitass/todo.txt-vim
" Version:     0.4

" Save context {{{1
let s:save_cpo = &cpo
set cpo&vim

" General options {{{1
" Some options lose their values when window changes. They will be set every
" time this script is invocated, which is whenever a file of this type is
" created or edited.
setlocal textwidth=0
setlocal wrapmargin=0

" Mappings {{{1
" Sort tasks {{{2
nnoremap <script> <silent> <buffer> <localleader>s :%sort<CR>
vnoremap <script> <silent> <buffer> <localleader>s :sort<CR>
nnoremap <script> <silent> <buffer> <localleader>s@ :%call TODOsort_by_context()<CR>
vnoremap <script> <silent> <buffer> <localleader>s@ :call TODOsort_by_context()<CR>
nnoremap <script> <silent> <buffer> <localleader>s+ :%call TODOsort_by_project()<CR>
vnoremap <script> <silent> <buffer> <localleader>s+ :call TODOsort_by_project()<CR>
nnoremap <script> <silent> <buffer> <localleader>sd :%call TODOsort_by_date()<CR>
vnoremap <script> <silent> <buffer> <localleader>sd :call TODOsort_by_date()<CR>
nnoremap <script> <silent> <buffer> <localleader>sdd :%call TODOsort_by_due_date()<CR>
vnoremap <script> <silent> <buffer> <localleader>sdd :call TODOsort_by_due_date()<CR>

" Change priority {{{2
nnoremap <script> <silent> <buffer> <localleader>j :call TODOprioritize_increase()<CR>
vnoremap <script> <silent> <buffer> <localleader>j :call TODOprioritize_increase()<CR>
nnoremap <script> <silent> <buffer> <localleader>k :call TODOprioritize_decrease()<CR>
vnoremap <script> <silent> <buffer> <localleader>k :call TODOprioritize_decrease()<CR>
nnoremap <script> <silent> <buffer> <localleader>a :call TODOprioritize_add('A')<CR>
vnoremap <script> <silent> <buffer> <localleader>a :call TODOprioritize_add('A')<CR>
nnoremap <script> <silent> <buffer> <localleader>b :call TODOprioritize_add('B')<CR>
vnoremap <script> <silent> <buffer> <localleader>b :call TODOprioritize_add('B')<CR>
nnoremap <script> <silent> <buffer> <localleader>c :call TODOprioritize_add('C')<CR>
vnoremap <script> <silent> <buffer> <localleader>c :call TODOprioritize_add('C')<CR>

" Insert date {{{2
nnoremap <script> <silent> <buffer> <localleader>d :call TODOreplace_date()<CR>
vnoremap <script> <silent> <buffer> <localleader>d :call TODOreplace_date()<CR>

" Mark done {{{2
nnoremap <script> <silent> <buffer> <localleader>x :call TODOmark_as_done()<CR>
vnoremap <script> <silent> <buffer> <localleader>x :call TODOmark_as_done()<CR>

" Mark all done {{{2
nnoremap <script> <silent> <buffer> <localleader>X :call TODOmark_all_as_done()<CR>

" Remove completed {{{2
nnoremap <script> <silent> <buffer> <localleader>D :call TODOremove_completed()<CR>

" Folding {{{1
" Options {{{2
setlocal foldmethod=expr
setlocal foldexpr=s:todo_fold_level(v:lnum)
setlocal foldtext=s:todo_fold_text()

" s:todo_fold_level(lnum) {{{2
function! s:todo_fold_level(lnum)
    " The match function returns the index of the matching pattern or -1 if
    " the pattern doesn't match. In this case, we always try to match a
    " completed task from the beginning of the line so that the matching
    " function will always return -1 if the pattern doesn't match or 0 if the
    " pattern matches. Incrementing by one the value returned by the matching
    " function we will return 1 for the completed tasks (they will be at the
    " first folding level) while for the other lines 0 will be returned,
    " indicating that they do not fold.
    return match(getline(a:lnum),'^[xX]\s.\+$') + 1
endfunction

" s:todo_fold_text() {{{2
function! s:todo_fold_text()
    " The text displayed at the fold is formatted as '+- N Completed tasks'
    " where N is the number of lines folded.
    return '+' . v:folddashes . ' '
                \ . (v:foldend - v:foldstart + 1)
                \ . ' Completed tasks '
endfunction

" Restore context {{{1
let &cpo = s:save_cpo

" File:        todo.txt.vim
" Description: Todo.txt filetype detection
" Author:      Leandro Freitas <freitass@gmail.com>
" License:     Vim license
" Website:     http://github.com/freitass/todo.txt-vim
" Version:     0.4

" Export Context Dictionary for unit testing {{{1
function! s:get_SID()
    return matchstr(expand('<sfile>'), '<SNR>\d\+_')
endfunction
let s:SID = s:get_SID()
delfunction s:get_SID

function! TODO__context__()
    return { 'sid': s:SID, 'scope': s: }
endfunction

" Functions {{{1
function! s:remove_priority()
    :s/^(\w)\s\+//ge
endfunction

function! s:get_current_date()
    return strftime('%Y-%m-%d')
endfunction

function! TODOprepend_date()
    execute 'normal! I' . s:get_current_date() . ' '
endfunction

function! TODOreplace_date()
    let current_line = getline('.')
    if (current_line =~ '^\(([a-zA-Z]) \)\?\d\{2,4\}-\d\{2\}-\d\{2\} ') &&
                \ exists('g:todo_existing_date') && g:todo_existing_date == 'n'
        return
    endif
    execute 's/^\(([a-zA-Z]) \)\?\(\d\{2,4\}-\d\{2\}-\d\{2\} \)\?/\1' . s:get_current_date() . ' /'
endfunction

function! TODOmark_as_done()
    call s:remove_priority()
    call TODOprepend_date()
    execute 'normal! Ix '
endfunction

function! TODOmark_all_as_done()
    :g!/^x /:call TODOmark_as_done()
endfunction

function! s:append_to_file(file, lines)
    let l:lines = []

    " Place existing tasks in done.txt at the beggining of the list.
    if filereadable(a:file)
        call extend(l:lines, readfile(a:file))
    endif

    " Append new completed tasks to the list.
    call extend(l:lines, a:lines)

    " Write to file.
    call writefile(l:lines, a:file)
endfunction

function! TODOremove_completed()
    " Check if we can write to done.txt before proceeding.

    let l:target_dir = expand('%:p:h')
    let l:todo_file = expand('%:p')
    " Check for user-defined g:todo_done_filename
    if exists("g:todo_done_filename")
        let l:todo_done_filename = g:todo_done_filename
    else
        let l:todo_done_filename = 'done.txt'
    endif
    let l:done_file = substitute(substitute(l:todo_file, 'todo.txt$', l:todo_done_filename, ''), 'Todo.txt$', l:todo_done_filename, '')
    if !filewritable(l:done_file) && !filewritable(l:target_dir)
        echoerr "Can't write to file '" . l:todo_done_filename . "'"
        return
    endif

    let l:completed = []
    :g/^x /call add(l:completed, getline(line(".")))|d
    call s:append_to_file(l:done_file, l:completed)
endfunction

function! TODOsort_by_context() range
    execute a:firstline . "," . a:lastline . "sort /\\(^\\| \\)\\zs@[^[:blank:]]\\+/ r"
endfunction

function! TODOsort_by_project() range
    execute a:firstline . "," . a:lastline . "sort /\\(^\\| \\)\\zs+[^[:blank:]]\\+/ r"
endfunction

function! TODOsort_by_date() range
    let l:date_regex = "\\d\\{2,4\\}-\\d\\{2\\}-\\d\\{2\\}"
    execute a:firstline . "," . a:lastline . "sort /" . l:date_regex . "/ r"
    execute a:firstline . "," . a:lastline . "g!/" . l:date_regex . "/m" . a:lastline
endfunction

function! TODOsort_by_due_date() range
    let l:date_regex = "due:\\d\\{2,4\\}-\\d\\{2\\}-\\d\\{2\\}"
    execute a:firstline . "," . a:lastline . "sort /" . l:date_regex . "/ r"
    execute a:firstline . "," . a:lastline . "g!/" . l:date_regex . "/m" . a:lastline
endfunction

" Increment and Decrement The Priority
:set nf=octal,hex,alpha

function! TODOprioritize_increase()
    normal! 0f)h
endfunction

function! TODOprioritize_decrease()
    normal! 0f)h
endfunction

function! TODOprioritize_add(priority)
    " Need to figure out how to only do this if the first visible letter in a line is not (
    :call TODOprioritize_add_action(a:priority)
endfunction

function! TODOprioritize_add_action(priority)
    execute 's/^\(([a-zA-Z]) \)\?/(' . a:priority . ') /'
endfunction

" File:        todo.txt.vim
" Description: Todo.txt filetype detection
" Author:      Leandro Freitas <freitass@gmail.com>
" License:     Vim license
" Website:     http://github.com/freitass/todo.txt-vim
" Version:     0.1

autocmd BufNewFile,BufRead [Tt]odo.txt set filetype=todo
autocmd BufNewFile,BufRead *.[Tt]odo.txt set filetype=todo
autocmd BufNewFile,BufRead [Dd]one.txt set filetype=todo
autocmd BufNewFile,BufRead *.[Dd]one.txt set filetype=todo

