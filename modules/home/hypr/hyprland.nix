{ lib, config, pkgs, inputs, ... }: let
  cfg = config.homeModules.hypr.hyprland;
in {
  options.homeModules.hypr.hyprland = {
    enable = lib.mkEnableOption "Enable hyprland";
    settings = {
      keyboard-layout = lib.mkOption { 
        type = lib.types.str;  
        default = "us";
        description = "Keyboard layout"; 
      };
      border-size = lib.mkOption {
        type = lib.types.either lib.types.int lib.types.float;
        default = 2;
        description = "Border size in px";
      };
      rounding = lib.mkOption {
        type = lib.types.either lib.types.int lib.types.float;
        default = 10;
        description = "Border radius in px";
      };
      gaps-in = lib.mkOption {
        type = lib.types.either lib.types.int lib.types.float;
        default = 5;
        description = "Gaps-in in px";
      };
      gaps-out = lib.mkOption {
        type = lib.types.either lib.types.int lib.types.float;
        default = 10;
        description = "Gaps-out in px";
      };
      opacity = lib.mkOption {
        type = lib.types.float;
        default = 1;
        description = "Opacity from 0 to 1";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      brightnessctl
    ];

    wayland.windowManager.hyprland = {
      enable = true;
      xwayland.enable = true;
      systemd.enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;

      settings = {
        "$mod" = "SUPER";

        exec-once = [ 
          "dbus-update-activation-environment --systemd --all" 
        ];
      
        monitor = [ ",prefered,auto,1.25" ]; 
        env = [];

        general = {
          gaps_in = cfg.settings.gaps-in;
          gaps_out = cfg.settings.gaps-out;
          border_size = cfg.settings.border-size;
          layout = "dwindle";
        };

        input = {
          kb_layout = config.var.keyboard-layout;
          follow_mouse = 1;
          touchpad.natural_scroll = true;
        };

        decoration = {
          shadow.enabled = false;
          blur.enabled = false;
          rounding = cfg.settings.rounding;
          active_opacity = cfg.settings.opacity;
          inactive_opacity = cfg.settings.opacity;
        };

        dwindle = {
          pseudotile = true;
          preserve_split = true;
        };

        gestures = { workspace_swipe = true; };

        misc = {
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
        };

        bind = [
          "$mod, T, exec, wezterm"
          "$mod, F, exec, firefox"
          "$mod, Space, exec, wofi"
          "$mod, Q, killactive"
          "$mod, Escape, exit"
        ] ++ (builtins.concatLists (builtins.genList (i: [
          "$mod, code:1${toString i}, workspace, ${toString (i + 1)}"
          "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString (i + 1)}"
        ]) 9));

        bindm = [
          "$mod, mouse:272, movewindow"
          "$mod SHIFT, mouse:272, resizewindow"
        ];

        bindel = [
          ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
          ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
          ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
          ",XF86MonBrightnessUp, exec, brightnessctl s 5%+"
          ",XF86MonBrightnessDown, exec, brightnessctl s 5%-"
        ];
      };
    };
  };
}
