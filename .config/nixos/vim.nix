{ pkgs, ... }:
{
  environment.variables = { EDITOR = "vim"; };

  environment.systemPackages = with pkgs; [
    (vim-full.customize {
      name = "vim";
      vimrcConfig.packages.myplugins = with pkgs.vimPlugins; {
        start = [
          fzf-vim
          nord-vim
          vim-nix
          vim-abolish
          vim-repeat
          vim-surround
          vim-toml
          vim-commentary
          vim-fugitive
          vim-rhubarb
          vim-vinegar
        ];
        opt = [];
      };
     vimrcConfig.customRC = ''
       set runtimepath=~/.vim,$VIMRUNTIME
       source ~/.vim/vimrc
     '';
    }
  )];
}
