{ config, pkgs, ... }:

{
  home.stateVersion = "23.05";
    
  programs.git = {
    enable = true;
    userName = "Sergei Razgulin";
    userEmail = "sergei.razgulin@gmail.com";
    extraConfig = {
      core = {
        editor = "vim";
      };
    };
  };
}
