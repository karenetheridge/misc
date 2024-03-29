" Configuration file for vim 5.x, 6.x
" Some things require 5.3 (5.1 does not like += syntax)

" Karen Etheridge, ether@tcp.com, 1994-2007.
" Karen Etheridge, ether@csc.uvic.ca, 1995-1997
" Karen Etheridge, ether@cpan.org, 2008-

" vim has copious :help, and you can also ask me about anything that this
" file does.  If you just want syntax colouring or easy format filtering,
" don't take matters into your own hands - please come ask. :)

" <rant disclaimer="I wrote this when I was much younger and bitchier">
"
"   I bear no responsibility for use or misuse of this file in any way.
"   This file belongs in ~ether/.vimrc; I have no control of files living
"   anywhere else.
"
"   DO NOT USE THIS FILE if:
"   1. You are a new user to vim
"   2. You don't know what EVERYTHING in this file does
"   3. You aren't willing to accept total loss of your data as a result of
"      not listening to 1 or 2.
"
" This may seem draconian but I am tired of taking responsibility for other
" peoples' carelessness and expecting other peoples' custom configuration
" files to be intelligently intuitive.  I wrote this file primarily for
" MY USE; it is commented so I can remember what everything does, and perhaps
" for other people to learn from.  It is not intended to be used by other
" people verbatim, and some things WILL BREAK, guaranteed.
" </rant>


" Begin configuration.  Remember, some of these prefs may not apply to you!!!

" STARTUP

version 4.x             " I have read the 4.0 release notes.
set nocompatible        " I understand all the ways that vim != vi.
scriptencoding utf-8
set encoding=utf-8

"  autocmd!              " Remove ALL autocommands.

" INSERT MODE

" tabstop               " each ^T in the file is worth 8 columns
set softtabstop=2       " each time I bang on tab, give me two columns
set shiftwidth=2        " autoindents are worth two columns
set expandtab           " use spaces rather than tabs
" set wrapmargin=2        " go to next line when close to the edge
set listchars=tab:^.,trail:⋅,eol:$
set nolist
set nojoinspaces        " when joining, insert one space after [.?!], not two
set textwidth=100       " affects formatting (gq), wordwrapping etc; should be set before fo
set formatoptions+=j    " where it makes sense, remove a comment leader when joining lines
set showmatch           " when typing a bracket/brace/parenthesis, blip to the matching one
set formatoptions+=c    " auto-format comment as they are typed
set formatoptions-=o    " do not automatically insert the current comment leader after hitting 'o' or 'O' in Normal mode


" BEHAVIOUR

set scrolloff=5         " don't let the cursor go closer than 5 lines from edge
set nostartofline       " try to keep the cursor in the right column
" set verbose=1         " give some feedback
set title               " allow changing of the window title
set icon                " allow changing of the icon title
set incsearch           " jump to matches as they are found
set magic               " I want to search using regexps a lot
set ignorecase          " perform searches case-insensitive
set smartcase           " ...but not if the pattern contains uppercase
" set cpoptions-=c        " continue searching one character from current cursor
" set cpoptions+=f        " :read sets filename for current buffer
" set cpoptions+=W        " don't overwrite a readonly file unless :w! is used
set viminfo='100,\"50,n~/.viminfo    " configure viminfo file
set modelines=5         " respect modelines in first and last N lines of file
set splitbelow          " I prefer new windows to appear on the bottom
set splitright          " ... and the right

set nofileignorecase    " I only use case-sensitive filesystems
set nowildignorecase

set guioptions+=a       " copy the selected area into the global clipboard
set autowrite           " write the file contents on :next, previous etc
set redrawtime=10000    " default 2000; slowdown might be caused by a missing library

if has("folding")
"  set foldmethod=syntax
"  let perl_fold=1
  let perl_include_pod=1
  let perl_extended_vars=1
endif

set backspace=indent,eol,start

set termencoding=utf-8
set encoding=utf-8      " latin1 is not quite good enough anymore for a default

if $VIM_CRONTAB == "true"
  set nobackup
  set nowritebackup
endif

set secure              " disable unsafe commands in .vimrc files if I do not own them
                        " (e.g. autocommand, shell, write commands)
"DoMatchParen           " http://vimdoc.sourceforge.net/htmldoc/pi_paren.html

" to change a file's encoding: :write ++enc=utf-8


" APPEARANCE

set noshowmode          " I don't need to be told when in insert mode
set errorbells          " Make noise for error messages
" set ruler             " show cursor position
set shortmess=fnx       " shorten some messages
set background=dark     " Change to "light" when a white background
			" maybe we need a keybinding to toggle this
set laststatus=2        " always show status line, even for one window

" from http://vim.wikia.com/wiki/Show_fileencoding_and_bomb_in_the_status_line
if has("statusline")
 set statusline=%<%f\ %h%m%r%=%{\"[\".(&fenc==\"\"?&enc:&fenc).((exists(\"+bomb\")\ &&\ &bomb)?\",B\":\"\").\"]\ \"}%k\ %-14.(%l,%c%V%)\ %P
endif

" SPELLING

" SpellSetSpellchecker ispell

" default: let spell_auto_type = "tex,mail,text,html,sgml,otl,cvs,none"
let spell_auto_type = "tex,mail,text,html,sgml,otl,cvs,pod,none"

" KEYMAPS

" thanks Luke!
" F2: open file in p4 edit mode
" files=`perl -e "$,=\" \";print map{$_=\`readlink -f $_\`;}%;" $*`
"     map <F2> :set noro<CR>:!p4 edit %<CR>

" F2: toggles paste mode
    " map <F2>  :set invpaste<CR>:echo "Paste mode" &paste<CR>
    :set pt=<F2>

" thanks Luke!
" F3: /clear search highlighting xyz<CR>
noremap <F3>  :noh<CR>

" F4: chmod u+w
noremap <F4>  :!chmod u+w %<CR>
" F5: toggles list view
map <F5>  :set invlist<CR>

" F6: toggles syntax colouring
map <F6>  :set invsyntax<CR>

" ,dd -- inserts common perl debugging snippet on next line.
map ,dd   :set paste<CR>Ouse Data::Dumper;<CR>local $Data::Dumper::Sortkeys = 1;<ESC>:set nopaste<CR>o
map ,dm   :set paste<CR>Ouse Data::Dumper;<CR>local $Data::Dumper::Sortkeys = 1;<CR>local $Data::Dumper::Maxdepth = 2;<ESC>:set nopaste<CR>o
map ,##   :set paste<CR>Oprint STDERR "####### ",__LINE__,"\n";<ESC>:set nopaste<CR>o

" ,jd ,dh ,td -- inserts common test mojo response dump snippets
map ,jd   :set paste<CR>Ouse Data::Dumper;<CR>local $Data::Dumper::Sortkeys = 1;<CR>local $Data::Dumper::Maxdepth = 5;<CR>diag 'got response json: ', Dumper($t->tx->res->json);<ESC>:set nopaste<CR>o
map ,dh   :set paste<CR>Ouse Data::Dumper;<CR>local $Data::Dumper::Sortkeys = 1;<CR>local $Data::Dumper::Maxdepth = 5;<CR>diag 'got response headers: ', Dumper($t->tx->res->headers);<ESC>:set nopaste<CR>o
map ,td   :set paste<CR>Oprint STDERR "### got response: ", $t->tx->res->text;<ESC>:set nopaste<CR>o

" ,dl -- inserts common mojo log dump snippet
map ,dl   :set paste<CR>Ouse Data::Dumper;<CR>local $Data::Dumper::Sortkeys = 1;<CR>local $Data::Dumper::Maxdepth = 5;<CR>diag 'got log: ', Dumper($t->app->log->history);<ESC>:set nopaste<CR>o

" ,l -- compile test of current file
noremap ,l :!perl -Ilib -c %

map ,term :below terminal ++rows=10<CR>


" XXX for posterity:
" fix uses of lives_ok and throws_ok:
" :%s/lives_ok \({ [^}]\+ }\) \([^;]\+\);/is(    exception \1,    undef,    \2,);/gc
" :%s/throws_ok \({ [^}]\+ }\) \(qr\/[^/]\+\/\), \([^;]\+\);/like(exception \1,    \2,    \3);/gc


" AUTOCOMMANDS

if has("autocmd")
  filetype plugin indent on

  " https://www.reddit.com/r/vim/comments/gnkws5/convince_me_that_i_dont_need_this_in_my_vimrc/
  au CursorHold,CursorHoldI * checktime       " autodetect when files have changed externally

  " more filetype detection:
  au BufNewFile,BufRead,BufReadPre,BufWinEnter *.PL                 set filetype=perl
  au BufNewFile,BufRead,BufReadPre,BufWinEnter *.t                  set filetype=perl
  au BufNewFile,BufRead,BufReadPre,BufWinEnter cpanfile             set filetype=perl
  au BufNewFile,BufRead,BufReadPre,BufWinEnter cpanfile.snapshot    set filetype=yaml
  au BufNewFile,BufRead,BufReadPre,BufWinEnter *.html.ep            set filetype=html

  au BufNewFile,BufRead,BufReadPre,BufWinEnter *.vue                set filetype=javascript

  au BufNewFile,BufRead,BufReadPre,BufWinEnter Changes              set tw=78

  au BufNewFile,BufRead,BufReadPre,BufWinEnter *.conf               set filetype=conf

  " Turn off line wrap for common files
  au BufNewFile,BufRead,BufWinEnter db.*	setlocal nowrap
  au BufNewFile,BufRead,BufWinEnter /etc/*	setlocal nowrap

  au BufNewFile,BufRead,StdinReadPost *
    \ let s:l1 = getline(1) |
    \ if s:l1 =~ '^Return-Path: ' |
    \   setf mail |
    \ endif

  "au FileType python    setlocal foldmethod=indent
  au FileType diff      setlocal list
  au BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  " for editing mail in Mutt
  au FileType mail setlocal tw=75
  au FileType mail map to gg/^To<CR>A
  au FileType mail map cc gg/^Cc<CR>A
  au FileType mail map su gg/^Subject<CR>A
  au FileType mail map Bo gg}o

  " perforce submissions
  au FileType p4 setlocal tw=77 wrap noexpandtab ai

  au FileType perl set formatoptions+=l softtabstop=2 shiftwidth=2 textwidth=100

  au FileType go set formatoptions+=l softtabstop=4 shiftwidth=4 noexpandtab tabstop=4 nolist textwidth=100
  au FileType proto set formatoptions+=l shiftwidth=4 noexpandtab tabstop=4 nolist textwidth=100

  au FileType sql set textwidth=95

  " au FileType * source ~/.vim/plugin/tab.vim

  " au FileType make set list

  au FileType yaml set softtabstop=2  shiftwidth=2

  au FileType gitcommit set textwidth=78

  au FileType gitconfig set noexpandtab nolist shiftwidth=8 softtabstop=4 tabstop=4

  " load local override files
  au BufNewFile,BufRead,BufWinEnter * silent! source .vimlocal        " load .vimlocal files, but do not fail if nonexistent
  au BufNewFile,BufRead,BufWinEnter * silent! source %:h/.vimlocal    " and override with $dir_of_file/.vimlocal, if present

endif


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" SYNTAX HIGHLIGHTING AND GUI

colorscheme default

" for https://github.com/vim-perl/vim-perl
let perl_sub_signatures = 1


" experimental.. attempt to get colours right
set t_Co=16

let term=$TERM
if (!has("gui_running") && term == "cygwin")
    " as it turns out, turning this on breaks hlsearch in cygwin!
    set term=rxvt
endif


if has("syntax")
  if &t_Co > 2 || has("gui_running")
    syntax on
    set hlsearch
  endif
endif

set mouse=nv    " disable mouse in insert mode, etc.

if (!has("gui_running"))
    set mouse=      " disable the mouse from interfering!
    set background=dark
endif


" original: Comment        xxx term=bold cterm=bold ctermfg=6
" 1: red, 0:grey, 7:white, 6:magenta
highlight Comment term=bold cterm=bold ctermfg=DarkGrey

hi Normal guifg=White guibg=Black

" original: mailQuoted1    xxx links to Comment
au FileType mail highlight mailQuoted1 term=bold cterm=bold ctermfg=5

" settings for macvim...
"guifont	list of font names to be used in the GUI
set gfn=Monaco:h10
set noanti      " no anti-aliasing!

" fix colours on MacVim
if (has("gui_running"))
    " default:
    " IncSearch      xxx term=reverse cterm=reverse gui=reverse
    " Search         xxx term=reverse ctermfg=0 ctermbg=11 guifg=Black guibg=Yellow
  hi Search term=reverse cterm=reverse guifg=Black guibg=LightBlue
endif

" settings for http://vimdoc.sourceforge.net/htmldoc/pi_paren.html
hi MatchParen term=NONE ctermbg=2 guibg=#008f00


" PLUGINS
" https://github.com/junegunn/vim-plug
"call plug#begin()

" https://github.com/prabirshrestha/vim-lsp
"Plug 'prabirshrestha/vim-lsp'

" insert more Plug commands here

"call plug#end()


"" from fgs and drbrain, #vim, 2022-05-31.
" let g:ale_linters = {'rust': ['analyzer']}
" let g:ale_rust_rustfmt_options = '+stable'
" let g:ale_fix_on_save = 1
" 
" let g:ale_sign_column_always = 1
" let g:ale_sign_error = '⸭⸭'
" let g:ale_sign_warning = ' ⁂'
" let g:ale_rust_analyzer_executable = '/usr/local/bin/rust-analyzer'

" \ '*': ['remove_trailing_lines', 'trim_whitespace'],
"let g:ale_fixers = {
"      \ 'go': ['gofmt'],
"      \ 'rust': ['rustfmt'],
"      \}

nmap <silent> <C-]> <Plug>(ale_go_to_definition)

au FileType rust let g:ale_completion_enabled = 1
au FileType rust let g:airline#extensions#ale#enabled = 1  " requires vim-airline?
au FileType rust let g:ale_sign_column_always = 1

au FileType perl let g:ale_completion_enabled = 0





""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Below this point is stuff stolen from Neil... moving to above the line as I
" figure out what I want.

set vb		" use a visual flash instead of beeping
set ru		" display column, line info
set ai		" always do autoindenting
"disabled 2010-01-05 -- mouse turning on in 10.6.2 in screen session
"if has("mouse")
"  set mouse=nvi	" use mouse support in xterm
"endif



"""""""""""""""""
" here are davidl's settings -- check them out
"
"autoindent          equalprg=par        formatoptions=cq
"ignorecase          shiftwidth=4        ttyfast
"autowrite           expandtab
"history=50
"incsearch           smartcase
"ttymouse=xterm2
"directory=/tmp/
"foldcolumn=4        hlsearch
"ruler
"textwidth=40        t_vb=
"
"backspace=indent,eol,start
"
"dictionary=~/.ispell_british,~/.vim/CVIMSYN/engspchk.wordlist
"
"errorformat=%f:%l:%m
"
"makeprg=/usr/share/doc/vim/tools/efm_perl.pl -c % $*
"
"matchpairs=(:),{:},[:],<:>
"
"printoptions=paper:a4
"
"rulerformat=%30(%{P4Status()} %(%5l,%-6(%c%V%) %P%)%)
"
"runtimepath=~/.vim,/etc/vim,/usr/share/vim/vimfiles,/usr/share/vim/addons,/usr/share/vim/vim63,/usr/share/vim/vimfiles,/usr/share/vim/addons/after,~/.vim/after
"
"suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.c b,.ind,.idx,.ilg,.inx,.out,.toc
"
"titlestring=test.txt
"
"viminfo=/10,'10,r/mnt/zip,r/mnt/floppy,f0,h,"100
"
"wildmode=list:longest,full
"
"
"""""""""""""""""
"
" To do:
" - vimspell/aspell
" - better perl handling?
" - keymaps (e.g. toggling paste mode)
" - check out davidl's nifty options.
"
"
" - keybinding for 'set nohlsearch'
" - vim -c option for jumping to specific place in p4 submit forms
" - 'highlight' variable

"[23:50|lukec> vimrc tip: " map <F5> to open file in p4 edit mode
"[23:50|lukec> map <F5> :!p4 edit %^[:set noro^[
