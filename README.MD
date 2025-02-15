Raspberry Pi headless server setup
- connect keyboard and run:
  `sudo passwd nixos`
  `<password>`
  `<password>`
- connect via ssh using "nixos" and created password
  `sudo su root`
  `nixos-generate-config`

Useful commands:
  `nixos-rebuild switch`
  `nixos-rebuild switch --update`
  `nix-collect-garbage -d`
