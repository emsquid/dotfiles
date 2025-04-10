{ lib, config, ... }: let
  cfg = config.homeModules.firefox;
in {
  options.homeModules.firefox = {
    enable = lib.mkEnableOption "Enable firefox";
    extensions = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "List of firefox extensions to install";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.firefox = {
      enable = true;
      policies = {
        DisableTelemetry = true;
        DisableFirefoxStudies = true;
        DisablePocket = true;
        Extensions.Install = map (name: "https://addons.mozilla.org/firefox/downloads/latest/${name}/latest.xpi") cfg.extensions;      
      };
      profiles = {
        Emanuel = {
        settings = {
          "media.gmp-widevinecdm.version" = "system-installed";
          "media.gmp-widevinecdm.visible" = true;
          "media.gmp-widevinecdm.enabled" = true;
          "media.gmp-widevinecdm.autoupdate" = false;

          "media.eme.enabled" = true;
          "media.eme.encrypted-media-encryption-scheme.enabled" = true;
          };
        };
      };
    };

    stylix.targets.firefox.profileNames = [ "Emanuel" ];
  };
}
