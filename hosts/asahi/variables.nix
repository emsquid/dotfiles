{ lib, pkgs, ... }: 

{
  options = {
    var = lib.mkOption {
      type = lib.types.attrs;
      default = { };
      description = "Configuration variables";
    };
  };

  config.var = {
    keyboard-layout = "fr";
    time-zone = "Europe/Paris";
    default-locale = "en_US.UTF-8";

    editor = "helix";

    git = {
      user = "Emsquid";
      email = "template@pm.me";
    };

    theme = {
      name = "gruvbox_dark_hard";
      rounding = 10;
      gaps-in = 5;
      gaps-out = 5 * 2;
      opacity = 0.95;
      border-size = 2;

      font = {
        name = "JetBrains Mono Nerd Font";
        package = pkgs.nerd-fonts.jetbrains-mono;
      };
      font-size = 12;

      bar = {
        transparent = false;
        floating = true;
        position = "top";
      };
    };
  };
}
