{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }: let
    system = "aarch64-linux"; 
  in {
    devShells.${system}.default = let
      pkgs = import nixpkgs { inherit system; };
    in pkgs.mkShell {
      packages = with pkgs; [
        gcc
        gnumake
        cmake
        flex
        bison
      ];

      shellHook = "exec zsh";
    };
  };
}
