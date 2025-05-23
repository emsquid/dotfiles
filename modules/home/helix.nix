{ lib, config, pkgs, ... }: let
  cfg = config.homeModules.helix;
in {
  options.homeModules.helix = {
    enable = lib.mkEnableOption "Enable helix";
    theme = lib.mkOption {
      type = lib.types.str;
      default = null;
      description = "Helix theme name";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.helix = {
      enable = true;

      settings = {
        theme = lib.mkIf (cfg.theme != null) (lib.mkForce cfg.theme);      
        editor = {
          line-number = "relative";
          bufferline = "always";
          mouse = false;
          color-modes = true;
          cursor-shape = {
            normal = "block";
            insert = "bar";
            select = "underline";
          };
          soft-wrap.enable = true;
        };

        keys = {
          normal = {
            C-s = ":w";
            C-q = ":q";
            C-f = ":format";
          };
        };
      };

      languages = {
        language = [{
          name = "python";
          formatter = { command = "black"; args = ["-" "--quiet"]; };
        }];
        language-server.tinymist.config = {
          # exportPdf = "onSave";
          formatterMode = "typstyle";
          formatterPrintWidth = 80;
        };
      };
    };

    home.packages = with pkgs; [
      nil
    ];
  };
}
