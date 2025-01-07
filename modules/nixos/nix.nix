{ lib, config, ... }: let
  cfg = config.nixosModules.nix;
in {
  options.nixosModules.nix = {
    optimise-store = lib.mkEnableOption "Enable nix store optimisation";
    collect-garbage = lib.mkEnableOption "Enable nix garbage collector";
    generation-limit = lib.mkOption {
      type = lib.types.nullOr (lib.types.ints.between 1 120);
      default = null;
      description = "Maxime number of generations to keep";
    };
  };

  config = {
    nix = {
      settings = {
        experimental-features = [ "nix-command" "flakes" ];
        auto-optimise-store = cfg.optimise-store;
      };
      gc = lib.mkIf cfg.collect-garbage {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 1w";
      };
    };

    boot.loader.systemd-boot.configurationLimit = cfg.generation-limit;
  };
}
