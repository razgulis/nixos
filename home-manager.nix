{ config, pkgs, ... }:

{
  home.stateVersion = "23.05";
    
  programs.git = {
    enable = true;
    userName = "Sergei Razgulin";
    userEmail = "sergei.razgulin@gmail.com";
    extraConfig = {
      core.editor = "vim";
      merge.tool = "vimdiff";
      merge.conflicstyle = "diff3";
      alias = {
        co = "checkout";
        ci = "commit";
        st = "status";
        br = "branch";
      };
    };
  };

  programs.vim = {
    enable = true;
    extraConfig = ''
      set mouse=v
    '';
  };
}
