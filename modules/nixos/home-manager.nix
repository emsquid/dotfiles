{ lib, config, inputs, system, host, user, ... }: let
  cfg = config.nixosModules.home-manager;
in {
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.nixosModules.home-manager = {
    enable = lib.mkEnableOption "Enable home-manager";
    path = lib.mkOption {
      type = lib.types.path;
      description = "Path to home-manager config";
    };
  };

  config = lib.mkIf cfg.enable {
    home-manager = {
      extraSpecialArgs = {
        inherit inputs;
        inherit system;
        inherit host;
        inherit user;
      };
      # useGlobalPkgs = true;
      useUserPackages = true;
      users.${user} = cfg.path;
    };
  };
}
