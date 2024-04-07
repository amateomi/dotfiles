{ pkgs, ... }:

{
  services.xserver = {
    enable = true;

    excludePackages = with pkgs; [ xterm ];

    layout = "us,ru";
    libinput.enable = true;
  };

  # Fix Wayland screen sharing
  xdg.portal.wlr.enable = true;
}
