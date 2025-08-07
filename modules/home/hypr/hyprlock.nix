{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.homeModules.hypr.hyprlock;
in
{
  options.homeModules.hypr.hyprlock = {
    enable = lib.mkEnableOption "Enable hyprlock";
  };

  config = lib.mkIf cfg.enable {
    # programs.hyprlock.enable = true;
    programs.swaylock.enable = true;
  };
}
