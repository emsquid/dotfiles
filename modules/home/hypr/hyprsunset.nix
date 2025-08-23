{
  lib,
  config,
  ...
}:
let
  cfg = config.homeModules.hypr.hyprsunset;
in
{
  options.homeModules.hypr.hyprsunset = {
    enable = lib.mkEnableOption "Enable hyprsunset support";
  };

  config = lib.mkIf cfg.enable {
    services.hyprsunset = {
      enable = true;
      settings = {
        profile = {
          time = "0:00";
          temperature = "4500";
        };
      };
    };
  };
}
