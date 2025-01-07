{ lib, config, ... }: let
  cfg = config.nixosModules.programs;
in {
  imports = [
    ./zsh.nix
    ./starship.nix
  ];

  options.nixosModules.programs.packages = lib.mkOption {
    type = lib.types.listOf lib.types.package;
    default = [];
    description = "List of packages to install";
  };

  config = {
    environment.systemPackages = cfg.packages;
  };
}
