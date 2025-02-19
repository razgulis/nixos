# Raspberry Pi headless server setup (with Blocky)
## Getting Started
connect keyboard and run:
```bash
  sudo passwd nixos
  <password>
  <password>
```
connect via ssh using "nixos" and created password
```bash
  sudo su root
  nixos-generate-config
```

## Useful commands
```bash
  nixos-rebuild switch
  nixos-rebuild switch --update
  nix-collect-garbage -d
  switch-to-configuration
```

## Rolling back
```bash
  sudo nix-env -p /nix/var/nix/profiles/system --list-generations
  sudo nixos-rebuild switch --rollback #this goes back one generation
  sudo nix-env -p /nix/var/nix/profiles/system --switch-generation 6
  sudo nixos-rebuild switch
```

## Pin a rollback generation
```bash
  # first create an additional link to the generation, so that it is not cleaned up during garbage collection:
  sudo ln -s /nix/var/nix/profiles/system-6 /nix/var/nix/keep-system-6
  # to release this version, simply delete the link
  sudo rm /nix/var/nix/keep-system-6 
```

## System Status and such
```bash
  # blocky
  systemctl status blocky
  journalctl -u blocky

  # home manager
  systemctl status home-manager-nixos.service
```
