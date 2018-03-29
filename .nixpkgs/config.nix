{
  packageOverrides = pkgs: {
    myVim = pkgs.vim_configurable.customize {
      name = "myVim";
      vimrcConfig = {
        customRC = ''
          source $HOME/.vimrc
        '';
        vam.knownPlugins = pkgs.vimPlugins;
        vam.pluginDictionaries = [
          { names = [
            "Syntastic"
            "vim-addon-nix"
            "youcompleteme"
            ]; 
          }
        ];
      };
    };
  };
}
