{ config, pkgs, ... }:

let
  ale-actionlint = pkgs.vimUtils.buildVimPlugin {
    name = "ale-actionlint";
    src = pkgs.fetchFromGitHub {
      owner = "hankei6km";
      repo = "ale-linter-actionlint.vim";
      rev = "a61411c52139daac3c00a6b364bb82b6599ff615";
      sha256 = "/OXaCKadX0Gpek5Hliz6Fas8DQH+LpB+61z1Gga+ABQ="; 
    };
  }; in
  # copilot-vim = pkgs.vimUtils.buildVimPlugin {
  #   name = "copilot-vim";
  #   src = pkgs.fetchFromGitHub {
  #     owner = "github";
  #     repo = "copilot.vim";
  #     rev = "a12fd5672110c8aa7e3c8419e28c96943ca179be";
  #     sha256 = "sha256-McrihGscbvt2lqHil3NxHUfgx/IAFDf7tdbBkv4vTK4="; 
  #   };
  # }; in 
{


  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [ 
    git
    ripgrep
    fzf
    fd
    tree
    jq
    yq-go
    gh
    shellcheck
    # xclip
    ffmpeg
    lazygit
    wget
    awscli2
    # openshell
    colima
    alacritty


    ((vim-full.override { }).customize {
    # ((vim-full.override {  guiSupport = false; }).customize {
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
          jedi-vim
          ale
          # vimwiki
          ale-actionlint
          quick-scope
          # copilot-vim
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
  # programs.vim.darwinSupport = true;
  system.primaryUser = "nikolaypisanchev";

  # Auto upgrade nix package and the daemon service.
  # services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true;  # default shell on catalina
  # programs.fish.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
