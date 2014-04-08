" FILE: "/home/johannes/ruby.vim"
" Last Modification: "Mon, 06 May 2002 23:42:11 +0200 (johannes)"
" Additional settings for Ruby
" Johannes Tanzler, <jtanzler@yline.com> 

" Matchit for Ruby: '%' {{{
" 
"   This function isn't very sophisticated. It just takes care of indentation.
" (I've written it, because I couldn't extend 'matchit.vim' to handle Ruby
" files correctly (that's because everything in Ruby ends with 'end' -- no
" 'endif', 'endclass' etc.))
" 
" If you're on the line `if x', then the cursor will jump to the next line
" with the same indentation as the if-clause. The same is true for a whole
" bunch of keywords -- see below for details.
"
" Since brave programmers use indentation, this will work for most of you, I
" hope. At least, it works for me. ;-)
" }}}
function! s:Ruby_Matchit()

    let block_start_words = 'if\|do\|unless\|elsif\|else\|case\|when\|while\|'
          \.'until\|def\|module\|class'
    " use default matching for parenthesis, brackets and braces:
    if strpart(getline("."), col(".")-1, 1) =~ '(\|)\|{\|}\|\[\|\]'
      normal! %
      return
    endif

    " use word under cursor if it looks like a block beginning/ending keyword
    sil! let starting_curr_word = expand('<cword>')
    if starting_curr_word !~ '\<\(' . block_start_words . '\|end\)\>' 
      " otherwise, use the word at the beginning of the line
      " remember where we were in case we abort
      normal! mZ
      normal! ^
      sil! let starting_curr_word = expand('<cword>')
    endif
    if starting_curr_word == "" 
	return 
    endif
    
    let spaces = strlen(matchstr(getline("."), "^\\s*"))

    if starting_curr_word =~ '\<end\>'
	while 1
	    normal! k
	    if strlen(matchstr(getline("."), "^\\s*")) == spaces
			\&& getline(".") !~ "^\\s*$"
			\&& getline(".") !~ "^#"
                " Go to beginning of line unless it is not a block-starting
                " word in which case we go to the end of line 
                " (handles cases like:  describe "x" do)
		normal! ^
                sil! let ending_curr_word = expand('<cword>')
                if ending_curr_word !~ '\<\(' . block_start_words . '\)\>'
                  normal! $
                endif
		break
	    elseif line(".") == 1
                normal! `Z
		break
	    endif
	endwhile
    elseif starting_curr_word =~ '\<\(' . block_start_words . '\)\>'
	while 1
	    normal! j
	    if strlen(matchstr(getline("."), "^\\s*")) == spaces
			\&& getline(".") !~ "^\\s*$"
			\&& getline(".") !~ "^#"
		normal! ^
		break
	    elseif line(".") == line("$")
                normal! `Z
		break
	    endif
	endwhile
    else
      normal! `Z
    endif

endfunction

nnoremap <buffer> % :call <SID>Ruby_Matchit()<CR>


