{ lib, config, ... }: let
  cfg = config.nixosModules.core.networking;
in {
  options.nixosModules.core.networking = {
    enable = lib.mkEnableOption "Enable networking support";
  };

  config = lib.mkIf cfg.enable {
    networking = {
      networkmanager = {
        enable = true;
        wifi.backend = "iwd";
      };
      wireless.iwd = {
        enable = true;
        settings.General.EnableNetworkConfiguration = true;
      };
    };
  };
}
