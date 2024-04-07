{ pkgs, ... }:

{
  imports = [ <home-manager/nixos> ];

  # Don't forget to set a password with ‘passwd’
  users.users.amateomi = {
    isNormalUser = true;
    description = "Andrey Sikorin";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    shell = pkgs.zsh;
  };

  home-manager.users.amateomi = {
    home = {
      stateVersion = "23.11";
      packages = with pkgs; [
        # Development
        vscode
        alacritty

        # Utility
        loupe
        clapper
        drawio

        # Communication
        firefox
        discord
        telegram-desktop
        spotify
      ];
    };
  };
}
