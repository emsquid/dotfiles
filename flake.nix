{
  description = "Emanuel's dot";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprpanel = {
      url = "github:Jas-SinghFSU/HyprPanel";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  
    wezterm = {
      url = "github:wez/wezterm/main?dir=nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # FIXME
    widevine.url = "github:epetousis/nixos-aarch64-widevine";
    apple-silicon-support.url = "github:tpwrules/nixos-apple-silicon";
  };

  outputs = { self, nixpkgs, home-manager, ... } @ inputs: let
    system = "aarch64-linux";
    host = "asahi";
    user = "emanuel";
    # pkgs = import nixpkgs { inherit system; };
  in {
    nixosConfigurations.${host} = nixpkgs.lib.nixosSystem {
      specialArgs = { 
        inherit inputs; 
        inherit system;
        inherit host;
        inherit user;
      };  
      modules = [ 
        { nixpkgs.overlays = [ inputs.hyprpanel.overlay inputs.widevine.overlays.default ]; }
        ./hosts/${host}/nixos.nix 
      ];
    };
  };
}
