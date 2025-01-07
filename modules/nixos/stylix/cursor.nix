{ lib, config, pkgs, ... }: let
  cfg = config.nixosModules.stylix.cursor;
in {
  options.nixosModules.stylix.cursor = {
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.vanilla-dmz;
      description = "Package providing the cursor theme";
    };
    name = lib.mkOption {
      type = lib.types.str;
      default = "Vanilla-DMZ";
      description = "The cursor name within the package";
    };
    size = lib.mkOption {
      type = lib.types.int;
      default = 32;
      description = "The cursor size.";
    };
  };

  config = {
    stylix.cursor = cfg;
  };
}
