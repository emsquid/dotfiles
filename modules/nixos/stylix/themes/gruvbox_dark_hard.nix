{ lib, config, pkgs, ...}: let
  cfg = config.nixosModules.stylix.themes.gruvbox_dark_hard;
in {
  options.nixosModules.stylix.themes.gruvbox_dark_hard = {
    enable = lib.mkEnableOption "Enable gruvbox_dark_hard theme";
  };

  config = lib.mkIf cfg.enable {
    stylix = {
      polarity = "dark";
      image = pkgs.fetchurl {
        url = "https://github.com/qxb3/conf/blob/yume/.config/swww/gruvbox/default.png?raw=true";
        sha256 = "sha256-lEUo9hKVBwwo5AvKJnz5v+CwF7QA3enrS8PZiA6vEZA=";
      };
      base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
    };
  };
}
