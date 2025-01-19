{ lib, config, ... }: let
  cfg = config.nixosModules.management.power;
in {
  options.nixosModules.management.power = {
    enable = lib.mkEnableOption "Enable power management";
  };

  config = lib.mkIf cfg.enable {
    powerManagement.enable = true;
    services.tlp = {
      enable = true;
      settings = {
        START_CHARGE_THRESH_BAT0 = 40; 
        STOP_CHARGE_THRESH_BAT0 = 80;
      };
    };
  };
}
