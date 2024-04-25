{ config, pkgs, ... }:

{
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [ 
    git
    ripgrep
    fzf
    fd

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
  )

  ];
  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  # environment.darwinConfig = "$HOME/.config/nixpkgs/darwin/configuration.nix";

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true;  # default shell on catalina
  # programs.fish.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
