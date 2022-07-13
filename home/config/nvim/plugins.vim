"
" ~/.config/nvim/plugins.vim
"

scriptencoding utf-8


" ########################## PLUGINS INSTALLATION ##############################

try
	" Extracted from https://github.com/ctaylo21/jarvis/blob/master/config/nvim/plugins.vim
	" Check whether Vim-Plug is installed and install it if necessary
	" let plugpath = expand('<sfile>:p:h'). '/autoload/plug.vim'
	let plugpath = expand('~').'/.local/share/vim/autoload/plug.vim'
	if !filereadable(plugpath)
		if executable('curl')
			let plugurl = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
				call system('curl -fLo ' . shellescape(plugpath) . ' --create-dirs ' . plugurl)
			if v:shell_error
				echo "Error downloading Vim-Plug. Please install it manually.\n"
				exit
			endif
		else
			echo "Vim-Plug not installed. Please install it manually or install curl.\n"
			exit
		endif
	endif

	" Plugins will be downloaded under the specified directory.
	call plug#begin('~/.local/share/vim/plugged')

	" Declare the list of plugins.
		" ctaylo21's init.vim
		Plug 'Shougo/denite.nvim'                      "Fuzzy finding, buffer management
		Plug 'neoclide/coc.nvim', {'do': { -> coc#util#install()}}  " 'Intellisense Engine'
		Plug 'easymotion/vim-easymotion'               "Improved motion in Vim
		Plug 'ryanoasis/vim-devicons'                  "Icons
		Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
		Plug 'euclio/vim-markdown-composer'            "An asynchronous markdown preview plugin for Vim and Neovim.

		" Plug 'tpope/vim-sensible'
		Plug 'erichdongubler/vim-sublime-monokai'   "Favorite Color scheme
		Plug 'Yggdroot/indentLine'
		Plug 'scrooloose/nerdtree'                  "File explorer
		Plug 'Xuyuanp/nerdtree-git-plugin'
		Plug 'junegunn/fzf.vim'

		" Plug 'Shougo/neocomplete.vim'
		Plug 'tommcdo/vim-exchange'
		Plug 'ntpeters/vim-better-whitespace' "Trailing whitespace highlighting & automatic fixing
		Plug 'tpope/vim-surround'
		Plug 'jiangmiao/auto-pairs'
		Plug 'vim-scripts/CursorLineCurrentWindow'
		" Plug 'victormours/better-writing.vim'
		" Plug 'janko-m/vim-test'
		" Plug 'skywind3000/asyncrun.vim'
		Plug 'w0rp/ale'
		" Plug 'tpope/vim-fugitive'

		Plug 'tomtom/tcomment_vim'
		Plug 'vim-airline/vim-airline'        "Status bar
		Plug 'vim-airline/vim-airline-themes'

		" vonbrownie's init.vim
		Plug 'airblade/vim-gitgutter'
		Plug 'vim-syntastic/syntastic'

		Plug 'tpope/vim-sleuth'

	" List ends here. Plugins become visible to Vim after this call.
	call plug#end()

	colorscheme sublimemonokai

	" Import Vim-Powerline
	" set rtp+=~/.pyenv/versions/3.7.3/lib/python3.7/site-packages/powerline/bindings/vim





	" ########################## PLUGINS CONFIGURATION #########################

	" =========================== DENITE =======================================
	"Wrap in try/catch to avoid errors on initial install before plugin is available
	" Use ack for searching current directory for files
	" By default, ack will respect rules in .gitignore
	"   --files: Print each file that would be searched (but don't search)
	"   --glob:  Include or exclues files for searching that match the given glob
	"            (aka ignore .git files)
	"
	call denite#custom#var('file/rec', 'command', ['ack', '--files', '--glob', '!.git'])

	" Use ack in place of "grep"
	call denite#custom#var('ack', 'command', ['ack'])

	" Custom options for ack
	"   --vimack:  Show results with every match on it's own line
	"   --hidden:   Search hidden directories and files
	"   --heading:  Show the file name above clusters of matches from each file
	"   --S:        Search case insensitively if the pattern is all lowercase
	call denite#custom#var('ack', 'default_opts', ['--hidden', '--vimgack', '--heading', '-S'])

	" Recommended defaults for ack via Denite docs
	call denite#custom#var('ack', 'recursive_opts', [])
	call denite#custom#var('ack', 'pattern_opt', ['--regexp'])
	call denite#custom#var('ack', 'separator', ['--'])
	call denite#custom#var('ack', 'final_opts', [])

	" Remove date from buffer list
	call denite#custom#var('buffer', 'date_format', '')

	" Open file commands
	call denite#custom#map('insert,normal', "<C-t>", '<denite:do_action:tabopen>')
	call denite#custom#map('insert,normal', "<C-v>", '<denite:do_action:vsplit>')
	call denite#custom#map('insert,normal', "<C-h>", '<denite:do_action:split>')

	" Custom options for Denite
	"auto_resize             - Auto resize the Denite window height automatically.
	"prompt                  - Customize denite prompt
	"direction               - Specify Denite window direction as directly
	"                          below current pane
	"winminheight            - Specify min height for Denite window
	"highlight_mode_insert   - Specify h1-CursorLine in insert mode
	"prompt_highlight        - Specify color of prompt
	"highlight_matched_char  - Matched characters highlight
	"highlight_matched_range - matched range highlight
	let s:denite_options = {'default' : {
	\ 'auto_resize': 1,
	\ 'prompt': 'λ:',
	\ 'direction': 'rightbelow',
	\ 'winminheight': '10',
	\ 'highlight_mode_insert': 'Visual',
	\ 'highlight_mode_normal': 'Visual',
	\ 'prompt_highlight': 'Function',
	\ 'highlight_matched_char': 'Function',
	\ 'highlight_matched_range': 'Normal'
	\ }}

	" Loop through denite options and enable them
	function! s:profile(opts) abort
		for l:fname in keys(a:opts)
			for l:dopt in keys(a:opts[l:fname])
				call denite#custom#option(l:fname, l:dopt, a:opts[l:fname][l:dopt])
			endfor
		endfor
	endfunction

	call s:profile(s:denite_options)

	" echo 'Denite not installed. It should work after running :PlugInstall'


	" ========================== COC.NVIM ======================================
	" Use <tab> for trigger completion and navigate to next complete item
	function! s:check_back_space() abort
		let col = col('.') - 1
		return !col || getline('.')[col - 1]  =~ '\s'
	endfunction

	inoremap <silent><expr> <TAB>
		\ pumvisible() ? "\<C-n>" :
		\ <SID>check_back_space() ? "\<TAB>" :
		\ coc#refresh()

	" Close preview window when completion is done.
	autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif

	" echo 'Coc.vim not installed. It should work after running :PlugInstall'
	" ==========================================================================


	" ========================= INDENTLINE =====================================
	let g:indentLine_char = '⋮'
	let g:better_whitespace_enabled = 0 " Don't highlight whitespace in red
	let g:strip_whitespace_on_save = 1

	" echo 'indentLine not installed. It should work after running :PlugInstall'
	" ==========================================================================


	" ========================== NERDTREE ======================================
	" Open a NerdTree if no file is given as CLI argument
	" autocmd StdinReadPre * let s:std_in=1
	" autocmd VimEnter * if argc() == 0 && !exists(“s:std_in”) | NERDTree | endif

	" Show hidden files/directories
	let g:NERDTreeShowHidden = 1

	" Or automatically close NerdTree when you open a file
	let NERDTreeQuitOnOpen = 1

	" Make NERDTree looks nice and disable that old “Press ? for help”
	let NERDTreeMinimalUI = 1
	let NERDTreeDirArrows = 1

	" Automatically delete the buffer of the file you just deleted with NerdTree
	let NERDTreeAutoDeleteBuffer = 1

	" Hide certain files and directories from NERDTree
	let g:NERDTreeIgnore = ['^\.DS_Store$', '^tags$', '\.git$[dir]', '\.idea$[dir]', '\.sass-cache$']

	let g:NERDTreeIndicatorMapCustom = {
		\ "Modified"  : "✹",
		\ "Staged"    : "✚",
		\ "Untracked" : "✭",
		\ "Renamed"   : "➜",
		\ "Unmerged"  : "═",
		\ "Deleted"   : "✖",
		\ "Dirty"     : "✗",
		\ "Clean"     : "✔︎",
		\ 'Ignored'   : '☒',
		\ "Unknown"   : "?"
	\ }


	if has("gui_running")
		" Show tab number (useful for Cmd-1, Cmd-2.. mapping)
		" For some reason this doesn't work as a regular set command,

		" (the numbers don't show up) so I made it a VimEnter event
		autocmd VimEnter * set guitablabel=%N:\ %t\ %M
	endif

	if has("gui_macvim")
		" Press Ctrl-Tab to switch between open tabs (like browser tabs) to
		" the right side. Ctrl-Shift-Tab goes the other way.
		noremap <C-Tab> :tabnext<CR>
		noremap <C-S-Tab> :tabprev<CR>

		" Switch to specific tab numbers with Command-number
		noremap <D-1> :tabn 1<CR>
		noremap <D-2> :tabn 2<CR>
		noremap <D-3> :tabn 3<CR>
		noremap <D-4> :tabn 4<CR>
		noremap <D-5> :tabn 5<CR>
		noremap <D-6> :tabn 6<CR>
		noremap <D-7> :tabn 7<CR>
		noremap <D-8> :tabn 8<CR>
		noremap <D-9> :tabn 9<CR>
		" Command-0 goes to the last tab
		noremap <D-0> :tablast<CR>
	endif


	" Command-/ to toggle comments
	map <D-/> :TComment<CR>
	imap <D-/> <Esc>:TComment<CR>i

	" Control-/ to toggle comments
	map <C-/> :TComment<CR>
	imap <C-/> <Esc>:TComment<CR>i

	" Leader-/ to toggle comments
	map <Leader>/ :TComment<CR>


	let g:ale_sign_error = '●'
	let g:ale_sign_warning = '.'
	let g:ale_lint_on_enter = 0
	let g:ale_lint_on_save = 1

	" echo 'NerdTree not installed. It should work after running :PlugInstall'
	" ==========================================================================


	" ========================== SYNTASTIC =====================================
	set statusline+=%#warningmsg#
	set statusline+=%{SyntasticStatuslineFlag()}
	set statusline+=%*

	let g:syntastic_always_populate_loc_list = 1
	let g:syntastic_auto_loc_list = 1
	let g:syntastic_check_on_open = 1
	let g:syntastic_check_on_wq = 0

	" let g:syntastic_python_pylint_exe = 'python3 -m pylint3'

	" echo 'Syntastic not installed. It should work after running :PlugInstall'
	" ==========================================================================

	" ##########################################################################





	" ############################## KEY MAPPINGS ##############################

	" =========================== DENITE =======================================
	"   ;         - Browser currently open buffers
	"   <leader>t - Browse list of files in current directory
	"   <leader>g - Search current directory for occurences of given term and
	"   close window if no results
	"   <leader>j - Search current directory for occurences of word under cursor
	nmap ; :Denite buffer -split=floating -winrow=1<CR>
	nmap <leader>t :Denite file/rec -split=floating -winrow=1<CR>
	nnoremap <leader>g :<C-u>Denite ack:. -no-empty<CR>
	nnoremap <leader>j :<C-u>DeniteCursorWord ack:.<CR>
	" ==========================================================================


	" ========================== COC.NVIM ======================================
	nmap <silent> <leader>dd <Plug>(coc-definition)
	nmap <silent> <leader>dr <Plug>(coc-references)
	nmap <silent> <leader>dj <Plug>(coc-implementation)

	" Reload icons after init source
	if exists('g:loaded_webdevicons')
	  call webdevicons#refresh()
	endif

	" echo 'Denite not installed. It should work after running :PlugInstall'
	" ==========================================================================


	" ========================== NERDTREE ======================================
	"# Toggle NERDTree on/off like Sublime Text
	nnoremap <Leader>kb :NERDTreeToggle<Enter>
	" "# Opens current file location in NERDTree
	" nmap <leader>f :NERDTreeFind<CR>

	" "# Directly open NerdTree quickly on the file
	" nnoremap <silent> <Leader>v :NERDTreeFind<CR>
	" "# This does that too...
	" autocmd vimenter * NERDTree

	" echo 'NerdTree not installed. It should work after running :PlugInstall'
	" ==========================================================================

	" ##########################################################################
catch
	echo 'vim-plug not installed!'
endtry

" ##############################################################################
