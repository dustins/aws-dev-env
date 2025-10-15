{
  description = "Pinned user env + project shells (non-NixOS)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, home-manager, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let pkgs = import nixpkgs { inherit system; };
        in {
          formatter = nixpkgs.legacyPackages.${system}.nixpkgs-fmt;

          # Per-project dev shells (exact versions pinned by flake.lock)
          devShells = {
            default = pkgs.mkShell {
              packages = with pkgs; [

              ];
            };
          };
        }
      ) // {
      # Home Manager in standalone mode (works on non-NixOS)
      homeConfigurations."clouddev" = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs { system = "x86_64-linux"; };
        modules = [
          ./home.nix
        ];
      };
    };
}

