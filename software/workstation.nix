{ pkgs, ... }:

{
  imports = [
    ./workstation/alacritty.nix
    ./workstation/bootloader.nix
    ./workstation/filesystem.nix
    ./workstation/git.nix
    ./workstation/gnome.nix
    ./workstation/kernel.nix
    ./workstation/networking.nix
    ./workstation/sound.nix
    ./workstation/time-locale.nix
    ./workstation/user.nix
    ./workstation/xserver.nix
    ./workstation/zsh.nix
  ];

  system.stateVersion = "23.11";
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    # General
    git
    neofetch
    htop
    tldr
    tmux
    bat
    xdg-utils
    pass
    zsh
    oh-my-zsh
    universal-ctags

    # Hardware utility
    lshw
    pciutils
    clinfo
    vulkan-tools
    libva-utils

    # Development
    gcc
    clang
    clang-tools
    gdb
    gnumake
    ninja
    cmake
    doxygen
    rustup
    python3
    nil
    nixpkgs-fmt
  ];
  fonts.packages = with pkgs; [
    jetbrains-mono
    noto-fonts
    noto-fonts-cjk
  ];

  virtualisation.docker.enable = true;
}
