with import <nixpkgs> {};
  vim_configurable.customize {
    name = "vim";
    vimrcConfig.customRC = ''
      set nocompatible  " Use Vim defaults
      
      set backspace=indent,eol,start  " reasonable backspace in insert mode
      
      set modelines=0   " Modelines are a security hazard
      
      " Formatting
      set expandtab   " Automatically expand tabs to spaces
      set tabstop=4   " tab width
      set shiftwidth=2  " wide, otherwise it's tabstop wide
      set softtabstop=2   " Simulated tabstop of 4 by using spaces and tabs
      set textwidth=78  " where to wrap lines
      set fo=crq      " when to wrap lines
      set autoindent  " set auto-indenting on
      
      " Display
      set ruler   " show the cursor position
      set nowrap  " don't warp display
      
      set laststatus=2
      set encoding=utf-8
      
      set showmatch   " show matching brackets
      set showcmd   " show (partial) command in status line
      " set statusline=%{fugitive#statusline()}
      
      "set wildmenu
      set wildmode=list:longest,full
      
      " Searching
      set incsearch   " incremental search
      set infercase   " handle case in a smart way in autocompletes
      set ignorecase  " ignore case in search
      set smartcase   " unless the search string contains uppercase
      set hlsearch  " highlighted search
      
      " Display whitespace characters nicely when using 'set list'
      set listchars=eol:$,tab:>-,trail:-,extends:>,precedes:<
      
      filetype plugin on    " enable filetype detection
      filetype indent on    " enable language-depenent indentation
      
      syntax enable
      set background=dark
      set t_Co=256
      highlight clear SignColumn
      
      " highlight RedundantSpaces ctermbg=red
      " match RedundantSpaces /\s\+$\| \+\ze\t\|\t/
  
      set number  " line numbers
      set scrolloff=5
      set hidden
      
      set nobackup
      
      set pastetoggle=<F2>
      
      "" vimwiki with markdown support
      "let g:vimwiki_ext2syntax = {'.md': 'markdown', '.markdown': 'markdown', '.mdown': 'markdown'}
      "" helppage -> :h vimwiki-syntax 
      "
      "" vim-instant-markdown - Instant Markdown previews from Vim
      "" https://github.com/suan/vim-instant-markdown
      "let g:instant_markdown_autostart = 0    " disable autostart
      "map <leader>md :InstantMarkdownPreview<CR>
      
      autocmd StdinReadPre * let s:std_in=1
    '';
  
    vimrcConfig.vam.knownPlugins = pkgs.vimPlugins;
    vimrcConfig.vam.pluginDictionaries = [
        { names = [
          "Syntastic"
          "vim-addon-nix"
          "vim-airline"
          "youcompleteme"
          "fugitive"
          "vim-go"
          "nerdtree"
          ]; }
      ];
}
