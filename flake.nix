{
  description = "Pinned user env + project shells (non-NixOS)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, home-manager, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = import nixpkgs { inherit system; };
      in {
        # Per-project dev shells (exact versions pinned by flake.lock)
        devShells = {
          default = pkgs.mkShell {
            packages = [
              pkgs.python3
              pkgs.nodejs
            ];
          };

          lisa = pkgs.mkShell {
            packages = [
              pkgs.python314
              pkgs.nodejs_24
            ];
          };

          mlspace = pkgs.mkShell {
            packages = [
              pkgs.python312
              pkgs.nodejs_22
            ];
          };
        };
      }
    ) // {
      # Home Manager in standalone mode (works on non-NixOS)
      homeConfigurations."clouddev" = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs { system = "x86_64-linux"; };
        modules = [
          ({pkgs, ...}: {
            home.username = "dustinps";
            home.homeDirectory = "/home/dustinps";
            home.stateVersion = "25.05";

            # Always-on tools (reproducible & pinned)
            home.packages = with pkgs; [
              home-manager
              ripgrep
              fd
              jq
              neovim
              git
              yq
              # nodejs_22
              # (python312.withPackages (ps: [ ps.uv ]))
            ];

            programs.zsh.enable = true;
            programs.fzf.enable = true;
            programs.lsd = {
              enable = true;
	      enableZshIntegration = true;
	    };

            programs.zsh.initContent = ''
              if [[ -f ~/.zshrc.orig ]]; then
                source ~/.zshrc.orig
              fi
            '';

            # Put flake/direnv at your fingertips
            programs.direnv = {
              enable = true;
              nix-direnv.enable = true;
	      enableZshIntegration = true;
            };

            programs.git = {
              enable = true;
              userName = "Dustin Sweigart";
              userEmail = "dustinps@amazon.com";

              # Optional: sign commits by default with GPG or SSH
              # signing = {
              #   key = "ssh-ed25519 AAAAC3Nz..."; # or GPG key ID
              #   signByDefault = true;
              # };

              # Customize global Git configuration
              extraConfig = {
                core = {
                  editor = "nvim";
                  autocrlf = "input";
                };
                pull.rebase = true;
                push.default = "current";
                color.ui = "auto";
                init.defaultBranch = "main";

                # Optional: enable credential caching or helpers
                credential.helper = "store";

                # Rebase and diff tweaks
                rebase.autosquash = true;
                diff.colorMoved = "default";
                merge.conflictstyle = "diff3";
              };

              # Optional aliases
              aliases = {
                co = "checkout";
                br = "branch";
                ci = "commit";
                st = "status";
                lg = "log --oneline --graph --decorate";
                undo = "reset --soft HEAD~1";
              };
            };

            # Unfree or other config can be centralized here
            nixpkgs.config.allowUnfree = true;
          })
        ];
      };
    };
}

