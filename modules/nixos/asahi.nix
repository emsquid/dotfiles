{ lib, config, pkgs, inputs, ... }: let
  cfg = config.nixosModules.asahi;
in {
  imports = [
    inputs.apple-silicon-support.nixosModules.apple-silicon-support 
  ];

  options.nixosModules.asahi = {
    enable = lib.mkEnableOption "Enable extra asahi support (sound/gpu/boot)";

    firmware-directory = lib.mkOption {
      type = lib.types.path;
      description = "Set asahi peripheral firmware directory";
    };

    swap-mods = lib.mkEnableOption "Swap option/command and fn/ctrl";

    # battery-threshold = {
    #   enable = lib.mkEnableOption "Enable battery threshold";

    #   start = lib.mkOption { 
    #     type = lib.types.ints.between 0 100; 
    #     default = 70; 
    #     description = "When to start charging";
    #   };

    #   end = lib.mkOption { 
    #     type = lib.types.ints.between 0 100; 
    #     default = 80; 
    #     description = "When to end charging";
    #   };
    # }; 
  };

  config = lib.mkIf cfg.enable {
    hardware = {
      asahi = {
        setupAsahiSound = true;
        useExperimentalGPUDriver = true;
        peripheralFirmwareDirectory = cfg.firmware-directory;
      };
      graphics.enable = true;
    };

    environment.systemPackages = with pkgs; [
      mesa
      mesa.drivers
    ];

    boot = {
      loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = false;
      };
      kernelParams = lib.mkIf cfg.swap-mods [
        "hid_apple.swap_opt_cmd=1"
        "hid_apple.swap_fn_leftctrl=1"
      ];  
    };  

    # services.udev.extraRules = lib.mkIf cfg.battery-threshold.enable ''
    #   KERNEL=="macsmc-battery", SUBSYSTEM=="power_supply", ATTR{charge_control_end_threshold}="${toString cfg.battery-threshold.end}", ATTR{charge_control_start_threshold}="${toString cfg.battery-threshold.start}"
    # '';
  };
}
