{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.homeModules.stremio;
in
{
  options.homeModules.stremio = {
    enable = lib.mkEnableOption "Enable stremio";
  };

  config = lib.mkIf cfg.enable {
    nixpkgs.config.allowUnfreePredicate =
      pkg:
      builtins.elem (lib.getName pkg) [
        "stremio-shell"
        "stremio-server"
      ];
    home.packages = with pkgs; [
      stremio
    ];
  };
}
