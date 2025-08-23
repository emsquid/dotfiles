{ lib, config, ... }:
let
  cfg = config.homeModules.firefox;
in
{
  options.homeModules.firefox = {
    enable = lib.mkEnableOption "Enable firefox/librewolf";
    extensions = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "List of firefox extensions to install";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.librewolf = {
      enable = true;
      policies = {
        DisableTelemetry = true;
        DisableFirefoxStudies = true;
        DisablePocket = true;
        Extensions.Install = map (
          name: "https://addons.mozilla.org/firefox/downloads/latest/${name}/latest.xpi"
        ) cfg.extensions;
      };
      profiles = {
        Emanuel = {
          settings = {
            "webgl.disabled" = false;
            "privacy.resistFingerprinting" = false;
            "privacy.clearOnShutdown.history" = false;
            "privacy.clearOnShutdown.cookies" = false;
            "network.cookie.lifetimePolicy" = 0;
            "cookiebanners.service.mode" = 2;

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

    stylix.targets.librewolf.profileNames = [ "Emanuel" ];
  };
}
