{
  packageOverrides = pkgs: {
    vix = pkgs.vim_configurable.customize {
      name = "vix";
      vimrcConfig = {
        customRC = ''
          source $HOME/.vimrc
        '';
        vam.knownPlugins = pkgs.vimPlugins;
        vam.pluginDictionaries = [
          { names = [
            "Syntastic"
            "vim-addon-nix"
            "vim-airline"
            "youcompleteme"
            "fugitive"
            ]; 
          }
        ];
      };
    };
  };
}
