{ config, user, ... }:

{
  imports = [
    ./variables.nix
    ../../modules/home
  ];

  home.username = user;

  homeModules = {
    firefox = {
      enable = true;
      extensions = [ "bitwarden-password-manager" "darkreader" "ublock-origin" ];
    };

    git = {
      enable = true;
      user = config.var.git.user;
      email = config.var.git.email;
    };

    helix = {
      enable = true;
      theme = config.var.theme.name;
    };

    hypr = {
      hypridle.enable = true;
      hyprlock.enable = true;
      hyprpaper.enable = true;

      hyprland = {
        enable = true;

        settings = { 
          keyboard-layout = config.var.theme.keyboard-layout;

          border-size = config.var.theme.border-size;
          rounding = config.var.theme.rounding;
          gaps-in = config.var.theme.gaps-in;
          gaps-out = config.var.theme.gaps-out;
          opacity = config.var.theme.opacity;
        };
      };

      hyprpanel = {
        enable = true;
        settings = {
          floating = config.var.theme.bar.floating;
          transparent = config.var.theme.bar.transparent;
          position = config.var.theme.bar.position;

          font = config.var.theme.font.name;
          font-size = config.var.theme.font-size;
  
          border-size = config.var.theme.border-size;
          rounding = config.var.theme.rounding;
          gaps-in = config.var.theme.gaps-in;
          gaps-out = config.var.theme.gaps-out;
          opacity = config.var.theme.opacity;
        };
      };
    };

    spotify.enable = true;
    wezterm.enable = true;
    
    wofi = {
      enable = true;
      settings = {
        font = config.var.theme.font.name;
        font-size = config.var.theme.font-size;
        rounding = config.var.theme.rounding;
      };
    };

    yazi.enable = true;
    zathura.enable = true;
    zsh.enable = true;
  };

  programs.home-manager.enable = true;

  home.stateVersion = "25.05";
}
