{ config, pkgs, host, user, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./variables.nix

    ../../modules/nixos
  ];

  networking.hostName = host;

  users.users.${user} = {
    isNormalUser = true;
    createHome = true;
    extraGroups = [ "wheel" ];
  };

  nixosModules = {
    asahi = {
      enable = true;
      swap-mods = true;
      battery-threshold.enable = true;
      firmware-directory = ./firmware;
    };

    home-manager = {
      enable = true;
      path = ./home.nix;
    };

    core = {
      audio.enable = true;
      bluetooth.enable = true;
      networking.enable = true;
      services.enable = true;

      locale = {
        time-zone = config.var.time-zone;
        keyboard-layout = config.var.keyboard-layout;
      };
    };

    nix = {
      optimise-store = true;
      collect-garbage = true;
      generation-limit = 10;
    };

    programs = {
      zsh.enable = true;
      starship.enable = true;
      packages = with pkgs; [
        dconf
        git
        helix
        tree
        unzip
        wget
        xdg-utils
        zip
        typst
        tinymist
      ];
    };

    stylix = {
      enable = true;
      themes.${config.var.theme.name}.enable = true;

      fonts =  {
        monospace = config.var.theme.font;
        sans-serif = config.var.theme.font;
        serif = config.var.theme.font;
        packages = [ pkgs.gyre-fonts ];
      };

      cursor = {
        package = pkgs.adwaita-icon-theme;
        name = "Adwaita";      
        size = 24;
      };
    };
  };

  environment.variables = {
    EDITOR = config.var.editor;
  };
  
  # TODO
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (subject.isInGroup("wheel"))
        return polkit.Result.YES;
    });
  '';

  system.stateVersion = "25.05";
}
