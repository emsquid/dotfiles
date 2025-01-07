{ lib, config, inputs, ... }: let
  cfg = config.nixosModules.stylix;
in {
  imports = [ 
    inputs.stylix.nixosModules.stylix
    ./cursor.nix
    ./fonts.nix
    ./themes
  ];

  options.nixosModules.stylix = {
    enable = lib.mkEnableOption "Enable stylix";
  };

  config = lib.mkIf cfg.enable {
    stylix.enable = true;
  };
}

