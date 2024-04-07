{
  imports = [
    "${builtins.fetchGit { url = "https://github.com/NixOS/nixos-hardware.git"; }}/common/pc/"
    "${builtins.fetchGit { url = "https://github.com/NixOS/nixos-hardware.git"; }}/common/pc/ssd"
    ./zephyrus-g14/amd-cpu.nix
    ./zephyrus-g14/amd-gpu.nix
    ./zephyrus-g14/nvidia-gpu.nix
  ];
}
