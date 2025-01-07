{ lib, config, ... }: let
  cfg = config.homeModules.spotify;
in {
  options.homeModules.spotify = {
    enable = lib.mkEnableOption "Enable spotify";
  };

  config = lib.mkIf cfg.enable {
    programs.spotify-player = {
      enable = true;

      settings = {
        theme = "default";
        enable_notify = false;

        device = {
          autoplay = true;
        };

        layout = {
          playback_window_position = "Bottom";
        };
      };
    };

    # TODO
    xdg.desktopEntries = {
      spotify = {
        name = "Spotify";
        genericName = "Music Player";
        exec = "wezterm start spotify_player";
        # terminal = true;
        categories = [ "Application" "Music" ];
      };
    };
  };
}
