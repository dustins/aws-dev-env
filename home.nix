{ pkgs, ... }: {
  # Home Manager in standalone mode (works on non-NixOS)
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
}
