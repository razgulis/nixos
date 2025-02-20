{ config, pkgs, ... }:

let
  sharedHomeConfig = import ./home-manager.nix;
in {
  imports = [
    /etc/nixos/hardware-configuration.nix
    (import (builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-23.05.tar.gz") {}).nixos
  ];

  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;

  time.timeZone = "America/Denver";
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true; # use xkbOptions in tty.
  };
  
  networking = {
    hostName = "nixos";
    interfaces.end0.ipv4.addresses = [{
      address = "192.168.1.200";
      prefixLength = 16;
    }];
    defaultGateway = "192.168.1.1";
    nameservers = [ "127.0.0.1" ];
    firewall.allowedTCPPorts = [ 22 53 ];
    firewall.allowedUDPPorts = [ 53 ];
  };

# TODO: probalby not needed, since we're running headless
#  nixpkgs = {
#    # You can add overlays here
#    overlays = [
#      # If you want to use overlays exported from other flakes:
#      # neovim-nightly-overlay.overlays.default
#
#      # Or define it inline, for example:
#      # (final: prev: {
#      #   hi = final.hello.overrideAttrs (oldAttrs: {
#      #     patches = [ ./change-hello-to-hi.patch ];
#      #   });
#      # })
#    ];
#    # Configure your nixpkgs instance
#    config = {
#      # Disable if you don't want unfree packages
#      allowUnfree = true;
#    };
#  };

# TODO: figure out if we need flakes (probably?)
#  nix = let
#    flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
#  in {
#    settings = {
#      # Enable flakes and new 'nix' command
#      experimental-features = "nix-command flakes";
#      # Opinionated: disable global registry
#      flake-registry = "";
#      # Workaround for https://github.com/NixOS/nix/issues/9574
#      nix-path = config.nix.nixPath;
#    };
#    # Opinionated: disable channels
#    channel.enable = false;
#
#    # Opinionated: make flake registry and nix path match flake inputs
#    registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
#    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
#  };

  # Home manager settings by user (see home-manager.nix)
  home-manager.users = {
    nixos = sharedHomeConfig;
    root = sharedHomeConfig;
  };

  users.users = {
    nixos = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      hashedPassword = "$6$80gp/ojgA8ZqDfbL$pyDmE661eynqmHl3UVemsw57vuxf5Yg.GQe9VTXGW8e4VnAcqgVWViJWz8s4hXIUOWpq.U0BpAjfetBrOAftz/";
    };
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    tldr
    btop
  ];

  # Shell Aliases
  programs.bash.shellAliases = {
    la = "ls -alh";
  };

  # Some programs need SUID wrappers, can be configured further or are started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # This setups a SSH server. Very important if you're setting up a headless system.
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      # Opinionated: use keys only.
      # Remove if you want to SSH using passwords
    };
  };

  # Blocky Ad Blocking, version 0.21
  services.blocky = {
    enable = true;
    settings = {
      port = 53;
      upstream.default = [
        "1.1.1.1"
        "https://one.one.one.one/dns-query" # Using Cloudflare's DNS over HTTPS server for resolving queries.
      ];
      # For initially solving DoH/DoT Requests when no system Resolver is available.
      bootstrapDns = {
        upstream = "https://one.one.one.one/dns-query";
        ips = [ "1.1.1.1" "1.0.0.1" ];
      };
      #Enable Blocking of certian domains.
      blocking = {
        blackLists = {
          #Adblocking
          ads = ["https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"];
          #Another filter for blocking adult sites
          #adult = ["https://blocklistproject.github.io/Lists/porn.txt"];
          #You can add additional categories
          special = [ "/etc/nixos/custom-block-list.txt" ];
        };
        #Configure what block categories are used
        clientGroupsBlock = {
          default = [ "ads" "special" ];
        #  kids-ipad = ["ads" "adult"];
        };
      };
      caching = {
        prefetching = true;
        minTime = "5m";
        maxTime = "30m";
      };
    };
  };

  system.stateVersion = "23.11";
}
