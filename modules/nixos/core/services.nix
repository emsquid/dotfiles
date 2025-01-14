{ lib, config, ... }: let
  cfg = config.nixosModules.core.services;
in {
  options.nixosModules.core.services = {
    enable = lib.mkEnableOption "Enable basic services";
  };

  config = lib.mkIf cfg.enable {
    services = {
      dbus.enable = true;
      gvfs.enable = true;
      libinput.enable = true;
      udisks2.enable = true;
      upower.enable = true;
      logind.extraConfig = "HandlePowerKey=ignore";
    };
  };
}
