#!/usr/bin/env bash
set -euo pipefail

function echo_color {
        echo -e "\033[32m${1}\033[39m"
}

# Update system
sudo pacman -Syu

# Install yay

# Install missing firmware
# Based on https://wiki.archlinux.org/title/Mkinitcpio#Possibly_missing_firmware_for_module_XXXX
sudo pacman -S linux-firmware linux-firmware-qlogic
yay -S upd72020x-fw aic94xx-firmware wd719x-firmware

# Install packages
sudo pacman -Syu wl-clipboard neofetch htop tldr tmux bat zsh libdbusmenu-glib ttf-jetbrains-mono \
                 gcc make ninja cmake gdb doxygen gtest cython ipython \
                 alacritty gnome-tweaks discord
yay -S intellij-idea-ultimate-edition-jre intellij-idea-ultimate-edition pycharm-professional clion-jre clion \
       gnome-browser-connector oh-my-zsh-git

# Git
# Based on https://git-scm.com/book/en/v2/Getting-Started-First-Time-Git-Setup
echo_color "Enter your full name for Git:"
read -r git_name
git config --global user.name "$git_name"
echo_color "Enter your Git mail:"
read -rp git_mail
git config --global user.email "$git_mail"
git config --global core.editor nano
git config --global init.defaultBranch master

# Generate SSH key for GitHub
# Based on https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent
echo_color "Enter GitHub mail (press ENTER if your would like to use Git mail):"
read -r mail
if [ -z "$mail" ]; then
    mail="$git_mail"
fi
ssh-keygen -t ed25519 -C "$mail"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
wl-copy < ~/.ssh/id_ed25519.pub
echo_color "Add SSH public key to GitHub (it's already in the clipboard)"
read -p "$*"  # Pause

# Generate GPG key for GitHub
# Based on https://docs.github.com/en/authentication/managing-commit-signature-verification/generating-a-new-gpg-key
gpg --default-new-key-algo rsa4096 --gen-key
gpg_id="$(gpg --list-secret-keys --keyid-format=long | grep -o "rsa4096/.[A-Z0-9]* " | cut -d "/" -f2)"
gpg_id="${gpg_id::-1}"
gpg --armor --export "$gpg_id" | wl-copy
git config --global user.signingkey "$gpg_id"
git config --global commit.gpgsign true
echo_color "Add GPG public key to GitHub (it's already in the clipboard)"
read -p "$*"  # Pause

# Fix missing console font
echo "FONT=tcvn8x16" | sudo tee -a /etc/vconsole.conf

# Fix Varmilo keyboard F keys
echo "options hid_apple fnmode=2" | sudo tee /etc/modprobe.d/hid_apple.conf
sudo mkinitcpio -P

# Fix time issue with dualboot
timedatectl set-local-rtc 1

# Nano
find /usr/share/nano -maxdepth 2 -type f | sed "s/^/include /" > .nanorc

# Zsh
chsh -s /usr/bin/zsh
cp ./.zshrc ~/.zshrc
curl https://raw.githubusercontent.com/Daivasmara/daivasmara.zsh-theme/master/daivasmara.zsh-theme | sudo tee $ZSH_CUSTOM/themes/daivasmara.zsh-theme
sudo git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
sudo git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# Alacritty
cp ./.alacritty.yml ~/.alacritty.yml
sudo sed -i "s/^Exec=alacritty/Exec=env WAYLAND_DISPLAY= alacritty/g" /usr/share/applications/Alacritty.desktop

# Settings
gsettings set org.gnome.desktop.sound event-sounds false
gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'us'), ('xkb', 'ru')]"

# Extensions
# Manually install Vitals, User Themes, Gnome 4x UI Improvements, Dash to Dock, Clipboard Indicator, Blur my Shell
