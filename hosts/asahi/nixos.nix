{ config, pkgs, inputs, host, user, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./variables.nix

    ../../modules/nixos
  ];

  nixpkgs.overlays = [ inputs.widevine.overlays.default ]; 

  networking.hostName = host;

  users.users.${user} = {
    isNormalUser = true;
    createHome = true;
    extraGroups = [ "wheel" ];
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nixosModules = {
    asahi = {
      enable = true;
      swap-mods = true;
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

    management = {
      power.enable = true;
      storage.enable = true;
    };

    programs = {
      zsh.enable = true;
      starship.enable = true;
      packages = with pkgs; [
        btop
        dconf
        git
        helix
        tree
        unzip
        wget
        xdg-utils
        zip
      ];
    };

    stylix = {
      enable = true;
      themes.${config.var.theme.name}.enable = true;

      fonts =  {
        monospace = config.var.theme.font;
        sans-serif = config.var.theme.font;
        serif = config.var.theme.font;
        packages = with pkgs; [
          gyre-fonts
          stix-two
        ];
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
    MOZ_GMP_PATH = [ "${pkgs.widevine-cdm-lacros}/gmp-widevinecdm/system-installed" ];
    DEVSHELLS = "/home/emanuel/.config/nixos/devshells";
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
