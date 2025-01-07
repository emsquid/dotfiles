# Dotfiles (NixOS)
This repository contains my NixOS system configuration. It is made to be modular, and should evolve in the near future to better match my tastes.

## Configuration
The main part of my configuration resolves around these 3 files:
- Sytem configuration [`nixos.nix`](hosts/asahi/nixos.nix)
- User configuration [`home.nix`](hosts/asahi/home.nix)
- Some variables [`variables.nix`](hosts/asahi/variables.nix)

## Installation
If you actually want to try it, you can run the following commands

```sh
# clone the repository
git clone git@github.com:emsquid/dotfiles.git

# move into it 
cd dotfiles

# update the flake
nix flake update

# rebuild from the flake
sudo nixos-rebuild switch --flake .
```
