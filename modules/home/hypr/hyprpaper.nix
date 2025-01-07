{ lib, config, ... }: let
  cfg = config.homeModules.hypr.hyprpaper;
in {
  options.homeModules.hypr.hyprpaper = {
    enable = lib.mkEnableOption "Enable hyprpaper";
  };

  config = lib.mkIf cfg.enable {
    services.hyprpaper = {
      enable = true;
      settings.ipc = "off";
    };
  };
}
