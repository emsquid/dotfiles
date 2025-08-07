{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.homeModules.niri;
in
{
  imports = [
    inputs.niri.homeModules.niri
  ];

  options.homeModules.niri = {
    enable = lib.mkEnableOption "Enable niri";
  };

  config = lib.mkIf cfg.enable {
    programs.niri = {
      enable = true;
    };
  };
}
