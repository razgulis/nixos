{ lib, config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;

  networking.hostName = "nixos";

  time.timeZone = "America/Denver";
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true; # use xkbOptions in tty.
  };
  
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

#  config = {
#    home-manager.users.nixos = {
#      # home-manager settings
#    
#      programs.git = {
#        enable = true;
#        userName = "Sergei Razgulin";
#        userEmail = "sergei.razgulin@gmail.com";
#      };
#    };
#  };

  users.users = {
    nixos = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      hashedPassword = "$6$80gp/ojgA8ZqDfbL$pyDmE661eynqmHl3UVemsw57vuxf5Yg.GQe9VTXGW8e4VnAcqgVWViJWz8s4hXIUOWpq.U0BpAjfetBrOAftz/";
      #   packages = with pkgs; [
      #     firefox
      #     tree
      #   ];
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    git
    tldr
    btop
  ];

  programs.bash.shellAliases = {
    la = "ls -alh";
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # This setups a SSH server. Very important if you're setting up a headless system.
  # Feel free to remove if you don't need it.
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      # Opinionated: use keys only.
      # Remove if you want to SSH using passwords
    };
  };

  # Blocky Ad Blocking
  #services.blocky = {
  #  enable = false;
  #  settings = {
  #    ports.dns = 53; # Port for incoming DNS Queries.
  #    upstreams.groups.default = [
  #      "https://one.one.one.one/dns-query" # Using Cloudflare's DNS over HTTPS server for resolving queries.
  #    ];
  #    # For initially solving DoH/DoT Requests when no system Resolver is available.
  #    bootstrapDns = {
  #      upstream = "https://one.one.one.one/dns-query";
  #      ips = [ "1.1.1.1" "1.0.0.1" ];
  #    };
  #    #Enable Blocking of certian domains.
  #    blocking = {
  #      blackLists = {
  #        #Adblocking
  #        ads = ["https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"];
  #        #Another filter for blocking adult sites
  #        #adult = ["https://blocklistproject.github.io/Lists/porn.txt"];
  #        #You can add additional categories
  #      };
  #      #Configure what block categories are used
  #      clientGroupsBlock = {
  #        default = [ "ads" ];
  #      #  kids-ipad = ["ads" "adult"];
  #      };
  #    };
  #    caching = {
  #      prefetching = true;
  #      minTime = "5m";
  #      maxTime = "30m";
  #    };
  #  };
  #};

  #networking.firewall.allowedTCPPorts = [ 22 53 ];
  #networking.interfaces.end0.ipv4.addresses = [ {
  #  address = "192.168.1.200";
  #  prefixLength = 24;
  #} ];

  system.stateVersion = "23.11";
}
