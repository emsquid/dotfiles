{ lib, config, ... }: let
  cfg = config.modules.category.name;
in {
  options.modules.category.name = {
    enable = lib.mkEnableOption "Enable name support";
  };

  config = lib.mkIf cfg.enable {
    
  };
}
