{ lib, config, ... }: let
  mkStrOption = default: lib.mkOption { type = lib.types.str; default = default; }; 
  cfg = config.nixosModules.core.locale;
in {
  options.nixosModules.core.locale = {
    time-zone = mkStrOption "Etc/UTC";
    keyboard-layout = mkStrOption "us";
    default-locale = mkStrOption "en_US.UTF-8";
  };

  config = {
    time.timeZone = cfg.time-zone;
    console.keyMap = cfg.keyboard-layout;
    i18n.defaultLocale = cfg.default-locale;
  };
}
