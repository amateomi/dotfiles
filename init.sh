#!/usr/bin/env bash
set -euo pipefail

function echo_color {
        echo -e "\033[32m${1}\033[39m"
}

# Install yay

# Install packages
sudo pacman -Syu wl-clipboard neofetch htop alacritty tldr tmux bat zsh cmake ninja gcc gnome-tweaks discord

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
gpg --armor --export "$gpg_id" | wl-copy
git config --global user.signingkey "$gpg_id"
git config --global commit.gpgsign true
echo_color "Add GPG public key to GitHub (it's already in the clipboard)"
read -p "$*"  # Pause

# Fix Varmilo keyboard F keys
echo "options hid_apple fnmode=2" | sudo tee /etc/modprobe.d/hid_apple.conf
sudo mkinitcpio -P

# Zsh

# Alacritty

# Settings
gsettings set org.gnome.desktop.sound event-sounds false

# GNOME Tweaks

# Extensions
