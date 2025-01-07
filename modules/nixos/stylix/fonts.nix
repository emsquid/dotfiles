{ lib, config, pkgs, ... }: let
  fontType = lib.types.submodule {
    options = {
      package = lib.mkOption {
        type = lib.types.package;
        description = "Package providing the font";
      };

      name = lib.mkOption {
        type = lib.types.str;
        description = "Name of the font within the package";
      };
    };
  };

  cfg = config.nixosModules.stylix.fonts;
in {
  options.nixosModules.stylix.fonts = {
    serif = lib.mkOption {
      type = fontType;
      default = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Serif";
      };
      description = "Serif font";
    };

    sans-serif = lib.mkOption {
      type = fontType;
      default = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Sans";
      };
      description = "Sans-serif font";
    };

    monospace = lib.mkOption {
      type = fontType;
      default = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Sans Mono";
      };
      description = "Monospace font";
    };

    emoji = lib.mkOption {
      type = fontType;
      default = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
      description = "Emoji font";
    };

    sizes = {
      desktop = lib.mkOption {
        type = with lib.types; (either ints.unsigned float);
        default = 10;
        description = "The font size (in pt) used in window titles/bars/widgets elements of the desktop";
      };

      applications = lib.mkOption {
        type = with lib.types; (either ints.unsigned float);
        default = 12;
        description = "The font size (in pt) used by applications";
      };

      terminal = lib.mkOption {
        type = with lib.types; (either ints.unsigned float);
        default = cfg.sizes.applications;
        description = "The font size (in pt) for terminals/text editors";
      };

      popups = lib.mkOption {
        type = with lib.types; (either ints.unsigned float);
        default = cfg.sizes.desktop;
        description = "The font size (in pt) for notifications/popups and in general overlay elements of the desktop.";
      };
    };

    packages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [];
      description = "A list of all the extra font packages that will be installed";
    };
  };

  config = {
    stylix = {
      fonts = {
        monospace = cfg.monospace;
        sansSerif = cfg.sans-serif;
        serif = cfg.serif;
        emoji = cfg.emoji;
        sizes = cfg.sizes;
      };
    };

    fonts.packages = cfg.packages;
  };
}
