{ lib, config, ... }: let
  cfg = config.homeModules.git;
in {
  options.homeModules.git = {
    enable = lib.mkEnableOption "Enable git";
    user = lib.mkOption { 
      type = lib.types.nullOr lib.types.str; 
      default = null;
      description = "Git user name";
    };
    email = lib.mkOption { 
      type = lib.types.nullOr lib.types.str; 
      default = null;
      description = "Git user email";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.git = {
      enable = true;
      userName = cfg.user;
      userEmail = cfg.email;
    };
  };
}
