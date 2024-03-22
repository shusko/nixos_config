{ config, pkgs, lib, options, specialArgs, modulesPath, nixosConfig, osConfig  }:

{
  imports = [
    ./alacritty.nix
    ./awesome_wm.nix
    ./firefox.nix
    ./git.nix
    ./neovim.nix
    ./direnv.nix
    ./rofi.nix
    ./shell.nix
  ];

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "sean";
  home.homeDirectory = "/home/sean";

  # Allow "unfree" packages
  # Required for Discord, Firefox
  nixpkgs.config.allowUnfreePredicate = _: true;

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    # Utils
    htop
    lsof
    strace
    xclip   # clipboard manager
    feh     # view images
    scrot   # take screenshots
    zip
    unzip

    # VPN
    openconnect

    # Work stuff
    jq
    docker-compose
    nodejs
    typescript
    sqlite

    # Video conferencing / streaming
    zoom-us
    droidcam
    obs-studio

    # Run launcher
    rofi

    # Hide mouse if not in use
    unclutter

    # Misc
    tree

    # Web apps
    brave
    discord

    # Email
    thunderbird

    # Password manager
    bitwarden

    # Pixel art
    aseprite
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    TERM = "alacritty";
  };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # TODO: Needs research
  # Secrets service (passwords, etc...)
  # services.gpg-agent = {
  #   enable = true;
  #   defaultCacheTtl = 1800;
  #   enableSshSupport = true;
  # };
}
