# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelModules = [
    "v4l2loopback" # Webcam loopback
  ];
  boot.extraModulePackages = [
    pkgs.linuxPackages.v4l2loopback # Webcam loopback
  ];

  # Enable networking
  networking.hostName = "seanbox";
  networking.networkmanager.enable = true;
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # GUI Desktop environment
  services.xserver = {
    enable = true;

    displayManager = {
      sddm.enable = true;
      defaultSession = "none+awesome";
    };
    windowManager.awesome = {
      enable = true;
      luaModules = with pkgs.luaPackages; [
        luarocks # package manager for Lua modules
        luadbi-mysql
      ];
    };

    # Configure keymap in X11
    layout = "us";
    xkbOptions = "caps:swapescape";
    xkbVariant = "";
  };

  # OpenGl (required for nvidia)
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  # nvidia setup
  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia = {
    modesetting.enable = true;

    powerManagement.enable = false;
    powerManagement.finegrained = false;

    open = false;

    nvidiaSettings = true;

    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # Docker
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
  };

  # Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    hsphfpd.enable = false; # handled by Wireplumber (pipewire)
  };
  services.blueman.enable = true;

  security.rtkit.enable = true;

  # Sound
  sound.enable = false; # Use pipewire for sound
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.sean = {
    isNormalUser = true;
    description = "sean";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    # packages = with pkgs; [];
  };

  # Never figured out how to move this to home-manager
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };

  # Allow unfree packages
  # (required for nvidia and steam)
  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = ["nix-command" "flakes"];

  # List packages installed in system profile. To search, run:
  environment.systemPackages = with pkgs; [
    # Basic system tools
    alacritty
    zsh
    git
    ripgrep
    pciutils
    usbutils

    # Text editor
    neovim

    # Compiler
    gcc
    gnumake

    # Networking tools
    wget
    curl
    openssl
    dig
    traceroute

    # GUI deps
    qt5ct
    gtk3

    # Audio setup
    pavucontrol
    pulseaudioFull
    pamixer

    # Webcam packages
    v4l-utils
    android-tools
    adb-sync
  ];

  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
  };

  environment.interactiveShellInit = ''
    alias vim='nvim'
    alias grep='rg'
  '';

  environment.variables = {
    # Prefer dark theme if possible
    GTK_THEME = "Adwaita:dark"; 
    QT_STYLE_OVERRIDE = "Adwaita-Dark";
    EDITOR = "nvim";
    TERM = "alacritty";
  };

  fonts.packages = with pkgs; [
    nerdfonts
  ];

  programs = {
    zsh = {
      enable = true;
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
      ohMyZsh = {
        enable = true;
        theme = "robbyrussell";
      };
    };
  };

  users.defaultUserShell = pkgs.zsh;
  environment.pathsToLink = [ "/share/zsh" ]; # Required for zsh autocomplete

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Firewall
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 80 443 3000 8080 8888 9000 ]; # For SSL VPN (and web dev)
    allowedUDPPorts = [ 80 443 3000 8080 8888 9000 ]; # For DTLS
    allowedUDPPortRanges = [
      { from = 4000; to = 4007; }
      { from = 8000; to = 8010; }
    ];
    checkReversePath = "loose"; # Allow connect back for VPN (can use false)
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
