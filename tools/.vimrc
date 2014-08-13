" ~/.vimrc (configuration file for vim only)
" skeletons
function! SKEL_spec()
	0r /usr/share/vim/current/skeletons/skeleton.spec
	language time en_US
	if $USER != ''
	    let login = $USER
	elseif $LOGNAME != ''
	    let login = $LOGNAME
	else
	    let login = 'unknown'
	endif
	let newline = stridx(login, "\n")
	if newline != -1
	    let login = strpart(login, 0, newline)
	endif
	if $HOSTNAME != ''
	    let hostname = $HOSTNAME
	else
	    let hostname = system('hostname -f')
	    if v:shell_error
		let hostname = 'localhost'
	    endif
	endif
	let newline = stridx(hostname, "\n")
	if newline != -1
	    let hostname = strpart(hostname, 0, newline)
	endif
	exe "%s/specRPM_CREATION_DATE/" . strftime("%a\ %b\ %d\ %Y") . "/ge"
	exe "%s/specRPM_CREATION_AUTHOR_MAIL/" . login . "@" . hostname . "/ge"
	exe "%s/specRPM_CREATION_NAME/" . expand("%:t:r") . "/ge"
	setf spec
endfunction
autocmd BufNewFile	*.spec	call SKEL_spec()
" filetypes
filetype plugin on
filetype indent on

map <silent> <F8> :!csfile.sh<CR> :cs add cscope.out<CR>
nnoremap <silent> <leader>fc : FufCoverageFile<CR>
nnoremap <silent> <leader>ff : FufFile<CR>

set runtimepath^=~/.vim/bundle/ctrlp.vim
set nocompatible
set hlsearch
set number
syntax enable
syntax on

set ts=4
set sw=4
set expandtab
set autoindent
set fileencodings=utf-8,gb2312,gbk,big5
set ruler
set statusline+=%f

set tags=tags
set tags+=./tags "add current directory's   generated tags file
set tags+=/usr/include/tags
set tags+=/Users/zhangchao/Qt5.2.1/5.2.1/clang_64/lib/QtCore.framework/Headers/tags
set tags+=/Users/zhangchao/Qt5.2.1/5.2.1/clang_64/lib/QtGui.framework/Headers/tags
set tags+=/Users/zhangchao/Qt5.2.1/5.2.1/clang_64/lib/QtWidgets.framework/Versions/5/Headers/tags

"-- omnicppcomplete setting --
set completeopt=menu,menuone
let OmniCpp_MayCompleteDot = 1 " autocomplete with .
let OmniCpp_MayCompleteArrow = 1 " autocomplete with ->
let OmniCpp_MayCompleteScope = 1 " autocomplete with ::
let OmniCpp_SelectFirstItem = 2 " select first item (but don't insert)
let OmniCpp_NamespaceSearch = 2 " search namespaces in this and included files
let OmniCpp_ShowPrototypeInAbbr = 1 " show function prototype  in popup window
let OmniCpp_GlobalScopeSearch=1
let OmniCpp_DisplayMode=1
let OmniCpp_DefaultNamespaces=["std"]

"NERD Tree
let NERDChristmasTree=1
let NERDTreeAutoCenter=1
let NERDTreeBookmarksFile=$VIM.'\Data\NerdBookmarks.txt'
let NERDTreeMouseMode=2
let NERDTreeShowBookmarks=1
let NERDTreeShowFiles=1
let NERDTreeShowHidden=1
let NERDTreeShowLineNumbers=1
let NERDTreeWinPos='left'
let NERDTreeWinSize=31
nnoremap <F2> :NERDTreeToggle<CR>

map <F3> :TlistToggle<CR>
map <F5> :!python %<CR>

"cscope setting
if has("cscope")
        set csprg=/usr/bin/cscope
        set csto=1
        set cst
        set nocsverb
" add any database in current directory
if filereadable("cscope.out")
        cs add cscope.out
endif
set csverb
endif

nmap <F12>s :cs find s <C-R>=expand("<cword>")<CR><CR>
nmap <F12>g :cs find g <C-R>=expand("<cword>")<CR><CR>
nmap <F12>c :cs find c <C-R>=expand("<cword>")<CR><CR>
nmap <F12>t :cs find t <C-R>=expand("<cword>")<CR><CR>
nmap <F12>e :cs find e <C-R>=expand("<cword>")<CR><CR>
nmap <F12>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
nmap <F12>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
nmap <F12>d :cs find d <C-R>=expand("<cword>")<CR><CR>
" ~/.vimrc ends here
