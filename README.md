# My system configuration based on NixOS

## Installation

1. Clone repository to home directory

   ```sh
   git clone git@github.com:amateomi/dotfiles.git ~/dotfiles
   ```

2. Change your `/etc/nixos/configuration.nix` to something like this:

   ```nix
   {
     imports = [
       ./hardware-configuration.nix
       ./dotfiles/hardware/varmilo-keyboard-fix.nix
       ./dotfiles/hardware/zephyrus-g14.nix
       ./dotfiles/software/workstation.nix
     ];
   }
   ```

3. Create symlink:

   ```sh
   sudo ln -s ~/dotfiles /etc/nixos/dotfiles
   ```

4. Build system:

   ```sh
   sudo nixos-rebuild switch
   ```

## Notes

Configuration creates user, but does not specify user password. This should be done manually.

Git is installed and partially configured, but SSH key must be created manually.
