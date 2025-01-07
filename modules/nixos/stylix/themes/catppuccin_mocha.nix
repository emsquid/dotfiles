{ lib, config, pkgs, ...}: let
  cfg = config.nixosModules.stylix.themes.catppuccin_mocha;
in {
  options.nixosModules.stylix.themes.catppuccin_mocha = {
    enable = lib.mkEnableOption "Enable catppuccin_mocha theme";
  };

  config = lib.mkIf cfg.enable {
    stylix = {
      polarity = "dark";
      image = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/orangci/walls-catppuccin-mocha/master/beach-path.jpg";
        sha256 = "sha256-iSUNffnzq3eI9qKUnSSEGOvXZugdbTURS0rcGbKa+R4=";
      };
      base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    };
  };
}
