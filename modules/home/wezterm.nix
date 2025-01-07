{ lib, config, pkgs, inputs, ... }: let
  cfg = config.homeModules.wezterm;
in {
  options.homeModules.wezterm = {
    enable = lib.mkEnableOption "Enable wezterm";
  };

  config = lib.mkIf cfg.enable {
    programs.wezterm = {
      enable = true;
      package = inputs.wezterm.packages.${pkgs.system}.default;
      extraConfig = #lua
      '' return {
        front_end = "OpenGL",
        enable_tab_bar = false,
        use_fancy_tab_bar = false,
        warn_about_missing_glyphs = false,
        window_close_confirmation = "NeverPrompt",
      } ''; 
    };
  };
}
