{ lib, config, pkgs, ... }: let
  cfg = config.nixosModules.programs.starship;
in {
  options.nixosModules.programs.starship = {
    enable = lib.mkEnableOption "Enable starship";
  };

  config = lib.mkIf cfg.enable {
    programs.starship = {
      enable = true;
      settings = (with builtins; fromTOML(readFile "${pkgs.starship}/share/starship/presets/nerd-font-symbols.toml")) // {
        format = "$all";
        add_newline = false;

        username = {
          style_user = "bold blue";
          format = "[$user]($style) in ";
          show_always = true;
        };

        directory = {
          style = "bold green";
        };

        character = {
          success_symbol = "[->](bold green)";
          error_symbol = "[✗](bold red)";
        };
      };
    };
  };
}
