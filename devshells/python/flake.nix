{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }: let
    system = "aarch64-linux"; 
    pkgs = import nixpkgs { inherit system; };
  in {
    devShells.${system}.default = pkgs.mkShell {
      packages = with pkgs; [
        (python3.withPackages(python-pkgs: [
          python-pkgs.python-lsp-server
          python-pkgs.pyflakes
          python-pkgs.black
          python-pkgs.matplotlib
          python-pkgs.numpy
          python-pkgs.pandas
          python-pkgs.pytorch
          python-pkgs.scikit-learn
        ]))
      ];

      shellHook = "exec zsh";
    };
  };
}
