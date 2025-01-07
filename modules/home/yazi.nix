{ lib, config, ... }: let
  cfg = config.homeModules.yazi;
in {
  options.homeModules.yazi = {
    enable = lib.mkEnableOption "Enable yazi";
  };

  config = lib.mkIf cfg.enable {
      programs.yazi = {
      enable = true;
      enableZshIntegration = true;

      settings = {
        log.enabled = false;
      };
    };

    # TODO
    xdg.desktopEntries = {
      yazi = {
        name = "Yazi";
        genericName = "File Manager";
        exec = "wezterm start yazi";
        # terminal = true;
        categories = [ "Application" ];
      };
    };
  };
}
