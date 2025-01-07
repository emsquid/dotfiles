{ lib, config, ...}: let
  cfg = config.nixosModules.core.audio;
in {
  options.nixosModules.core.audio = {
    enable = lib.mkEnableOption "Enable audio support";
  };

  config = lib.mkIf cfg.enable {
    services.pipewire = {
      enable = true;
      wireplumber.enable = true;
    };
  };
}
