{ lib, config, ...}: let
  cfg = config.nixosModules.core.bluetooth;
in {
  options.nixosModules.core.bluetooth = {
    enable = lib.mkEnableOption "Enable bluetooth support";
  };

  config = lib.mkIf cfg.enable {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = false;
    };
  };
}
