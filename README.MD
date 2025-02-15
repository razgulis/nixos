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
```
