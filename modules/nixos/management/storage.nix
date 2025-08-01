{ lib, config, ... }: let
  cfg = config.nixosModules.management.storage;
in {
  options.nixosModules.management.storage = {
    enable = lib.mkEnableOption "Enable storage management";
  };

  config = lib.mkIf cfg.enable {
    nix = {
      settings.auto-optimise-store = true;
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 5d";
      };
    };

    boot.loader.systemd-boot.configurationLimit = 10;
  };
}
