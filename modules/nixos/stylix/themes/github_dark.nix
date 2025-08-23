{ lib, config, pkgs, ...}: let
  cfg = config.nixosModules.stylix.themes.github_dark;
in {
  options.nixosModules.stylix.themes.github_dark = {
    enable = lib.mkEnableOption "Enable github_dark theme";
  };

  config = lib.mkIf cfg.enable {
    stylix = {
      polarity = "dark";
      image = pkgs.fetchurl {
        url = "https://w.wallhaven.cc/full/wq/wallhaven-wq2r8p.png";
        sha256 = "sha256-ODdYq4zozQiNe8qUr2rMbzi6G6KyQeMGZTELB6ZycHA=";
      };
      base16Scheme = "${pkgs.base16-schemes}/share/themes/github-dark.yaml";
    };
  };
}
