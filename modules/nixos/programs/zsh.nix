{ lib, config, pkgs, ... }: let
  cfg = config.nixosModules.programs.zsh;
in {
  options.nixosModules.programs.zsh = {
    enable = lib.mkEnableOption "Enable zsh";
  };

  config = lib.mkIf cfg.enable {
    users.defaultUserShell = pkgs.zsh;

    programs.zsh = {
      enable = true;
      enableCompletion = true;
    };
  };
}
