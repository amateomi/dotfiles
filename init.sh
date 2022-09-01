#!/usr/bin/env bash
set -euo pipefail

# Speed up dnf (Fedora only)
sudo echo -e "fastestmirror=True\nmax_parallel_downloads=10\ndefaultyes=True\nkeepcache=True" | sudo tee -a /etc/dnf/dnf.conf
sudo dnf autoremove
sudo dnf clean all

# Update System
sudo dnf upgrade --refresh

# Enable RPM Fusion
sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
                 https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# Enable Flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Enable Snap
sudo dnf install snapd
sudo ln -s /var/lib/snapd/snap /snap

# Install packages
sudo dnf install wl-clipboard neofetch htop alacritty zsh cmake ninja-build gnome-tweaks telegram discord
flatpak install flathub com.mattjakeman.ExtensionManager
sudo snap install clion --classic

# Git
# Based on https://git-scm.com/book/en/v2/Getting-Started-First-Time-Git-Setup
read -rp "Enter your full name for Git: " git_name
git config --global user.name "$git_name"
read -rp "Enter your Git mail: " git_mail
git config --global user.email "$git_mail"
git config --global core.editor nano
git config --global init.defaultBranch master

# Generate SSH key for GitHub
# Based on https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent
read -rp "Enter GitHub mail (press ENTER if your would like to use Git mail): " mail
if [ -z "$mail" ]; then
    mail="$git_mail"
fi
ssh-keygen -t ed25519 -C "$mail"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
wl-copy < ~/.ssh/id_ed25519.pub
echo "Add SSH public key to GitHub (it's already in the clipboard)"

# Generate GPG key for GitHub
# Based on https://docs.github.com/en/authentication/managing-commit-signature-verification/generating-a-new-gpg-key
gpg --full-generate-key
gpg_id="$(gpg --list-secret-keys --keyid-format=long | grep -o "ed25519/.[A-Z0-9]* " | cut -d "/" -f2)"
gpg --armor --export "$gpg_id" | wl-copy
echo "Add GPG public key to GitHub (it's already in the clipboard)"
git config --global user.signingkey "$gpg_id"
git config --global commit.gpgsign true

# Zsh

# Alacritty

# Settings

# GNOME Tweaks

# Extensions
