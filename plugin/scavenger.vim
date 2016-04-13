" vim:fenc=utf-8
"
" Copyright © 2016 KuoE0 <kuoe0.tw@gmail.com>
"
" Distributed under terms of the MIT license.

" --------------------------------
" Add our plugin to the path
" --------------------------------
python import sys
python import vim
python sys.path.append(vim.eval('expand("<sfile>:h")'))

" --------------------------------
" Initial variables
" --------------------------------
if !exists('g:scavenger_enable_highlight')
	let g:scavenger_enable_highlight = 1
endif

if !exists('g:scavenger_auto_clean_up_on_write')
	let g:scavenger_auto_clean_up_on_write = 0
endif

if !exists('g:scavenger_is_highlight')
	let g:scavenger_is_highlight = 0
endif

" --------------------------------
"  Function(s)
" --------------------------------
if has('python')

    function! CleanUp()
        python from scavenger import clean_up
        python clean_up()
    endfunc

    function! CleanUpMultipleEmptyLines()
        python from scavenger import clean_up_multiple_empty_lines
        python clean_up_multiple_empty_lines()
    endfunc

    function! CleanUpTrailingSpaces()
        python from scavenger import clean_up_trailing_spaces
        python clean_up_trailing_spaces()
    endfunc

    function! IsMultipleEmptyLinesExist()
        python from scavenger import is_multiple_empty_lines_exist
        python is_multiple_empty_lines_exist()
        if l:multiple_empty_lines_exist
            echo "There are multiple empty lines."
        endif
    endfunc

    function! IsTrailingSpacesExist()
        python from scavenger import is_trailing_spaces_exist
        python is_trailing_spaces_exist()
        if l:trailing_spaces_exist
            echo "There are trailing spaces."
        endif
    endfunc

	if g:scavenger_auto_clean_up_on_write
		autocmd BufWritePre * call CleanUp()
	endif
elseif has('python3')
    pyfile3 scavenger.py3
endif

function! ScavengerHighlightAll()
	let g:scavenger_is_highlight = 1
	" highlight the empty line more than one
	highlight MultipleEmptyLines ctermbg=red guibg=red
	call matchadd('MultipleEmptyLines', '\_^\_$\n\_^\_$\n')
	" highlight trailing space
	highlight TrailingSpaces ctermbg=red guibg=red
	call matchadd('TrailingSpaces', '\s\+$')
endfunc

function! ScavengerClearHighlight()
	let g:scavenger_is_highlight = 0
	call clearmatches()
endfunc

function! ScavengerToggleHighlight()
	if g:scavenger_is_highlight
		call ScavengerClearHighlight()
	else
		call ScavengerHighlightAll()
	endif
endfunc

if g:scavenger_enable_highlight
	call ScavengerHighlightAll()
endif

" --------------------------------
"  Expose our commands to the user
" --------------------------------

command! CleanUp call CleanUp()
command! CleanUpMultipleEmptyLines call CleanUpMultipleEmptyLines()
command! CleanUpTrailingSpaces call CleanUpTrailingSpaces()
command! ScavengerHighlightAll call ScavengerHighlightAll()
command! ScavengerClearHighlight call ScavengerClearHighlight()
command! ScavengerToggleHighlight call ScavengerToggleHighlight()
