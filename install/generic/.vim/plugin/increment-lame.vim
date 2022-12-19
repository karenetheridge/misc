"=============================================================================
" File: increment.vim
" Author: Stanislav Sitar (sitar@procaut.sk)
" Help:
" Put increment.vim into a plugin directory.
" Use in replacement strings
" :%s/my_token_word_to_be_replaced_by_the_auto_incremented_numbers/\=INC(1)/
" or
" :let I=95
" :%s/@/\=INC(5)/
" to replace each occurence of character @ with numbers starting with 100 and 
" growing by 5 (100, 105, 110, ...)
"=========================================================================


let g:I=0

function INC(increment)
	let g:I =g:I + a:increment
	return g:I
endfunction
