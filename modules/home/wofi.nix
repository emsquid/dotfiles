{ lib, config, ... }: let
  background = "#${config.lib.stylix.colors.base00}";
  background-alt = "#${config.lib.stylix.colors.base01}";
  foreground = "#${config.lib.stylix.colors.base05}";
  accent = "#${config.lib.stylix.colors.base0D}";

  cfg = config.homeModules.wofi;
in {
  options.homeModules.wofi = {
    enable = lib.mkEnableOption "Enable wofi";
    settings = {
      font = lib.mkOption { 
        type = lib.types.str;  
        default = "DejaVu Sans";
        description = "Font name"; 
      };
      font-size = lib.mkOption {
        type = lib.types.either lib.types.int lib.types.float;
        default = 12;
        description = "Font size in pt";
      };
      rounding = lib.mkOption {
        type = lib.types.either lib.types.int lib.types.float;
        default = 10;
        description = "Border radius in px";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.wofi = {
      enable = true;

      settings = {
        show = "drun";
        prompt = "Apps";
        width = 450;
        height = 300;
        normal_window = true;
        allow_markup = true;
        insensitive = true;
        hide_scroll = true;
        key_expand = "Tab";
        key_exit = "Escape";
      };

      style = lib.mkForce # css
        '' * {
            font-family: "${cfg.settings.font}";
            font-weight: 600;
            font-size: ${toString cfg.settings.font-size}pt;
          }

          #window {
            background-color: ${background};
            color: ${foreground};
            border-radius: ${toString cfg.settings.rounding}px;
          }

          #outer-box {
            padding: 20px;
          }

          #input {
            background-color: ${background-alt};
            color: ${foreground};
            padding: 12px;
          }

          #scroll {
            margin-top: 20px;
          }

          #inner-box {}

          #text {
            color: ${foreground};
          }

          #text:selected {
            color: ${foreground};
          }

          #entry {
            padding: 12px;
          }

          #entry:selected {
            background-color: ${accent};
            color: ${foreground};
          }

          #unselected {}

          #selected {}

          #input,
          #entry:selected {
            border-radius: ${toString cfg.settings.rounding}px;
          }
      '';
    };
  };
}
