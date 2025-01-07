{ lib, config, pkgs, ... }: let
  cfg = config.homeModules.hypr.hypridle;
in {
  options.homeModules.hypr.hypridle = {
    enable = lib.mkEnableOption "Enable hypridle support";
    timeout = {
      lock = lib.mkOption {
        type = lib.types.int;
        default = 300;
      };
      sleep = lib.mkOption {
        type = lib.types.int;
        default = 330;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.hypridle = {
      enable = true;
      settings = {
        general = {
          ignore_dbus_inhibit = false;
          lock_cmd = "pidof hyprlock || ${pkgs.hyprlock}/bin/hyprlock";
          before_sleep_cmd = "loginctl lock-session";
          after_sleep_cmd = "hyprctl dispatch dpms on";
        };

        listener = [
          {
            timeout = cfg.timeout.lock;
            on-timeout = "pidof hyprlock || ${pkgs.hyprlock}/bin/hyprlock";
          }
          {
            timeout = cfg.timeout.sleep;
            on-timeout = "systemctl suspend";
          }
        ];
      };
    };
  };
}
