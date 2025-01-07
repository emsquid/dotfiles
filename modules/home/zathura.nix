{ lib, config, ... }: let
  cfg = config.homeModules.zathura;
in {
  options.homeModules.zathura = {
    enable = lib.mkEnableOption "Enable zathura";
  };

  config = lib.mkIf cfg.enable {
    programs.zathura = {
      enable = true;

      options = {
        adjust-open = "width";
        render-loading = false;
      };
    };
  };
}
