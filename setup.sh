#!/usr/bin/env bash

set -euo pipefail

function dnf_update() {
  sudo echo -e "fastestmirror=True\nmax_parallel_downloads=10\ndefaultyes=True\nkeepcache=True" | sudo tee -a /etc/dnf/dnf.conf

  sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-"$(rpm -E %fedora)".noarch.rpm \
    https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-"$(rpm -E %fedora)".noarch.rpm

  flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

  sudo dnf upgrade --refresh
}

function install_nvidia() {
  sudo dnf install akmod-nvidia xorg-x11-drv-nvidia-cuda
}

function install_packages() {
  sudo dnf install util-linux-user neofetch htop tldr tmux bat zsh alacritty \
    g++ cmake doxygen cython ipython \
    jetbrains-mono-fonts gnome-tweaks gnome-extensions-app \
    discord telegram

  sudo flatpak install flathub com.spotify.Client

  # Install oh-my-zsh
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

  sudo dnf autoremove
  sudo dnf clean all
}

function setup_git() {
  # Git
  # Based on https://git-scm.com/book/en/v2/Getting-Started-First-Time-Git-Setup
  echo_color "Git setup..."
  echo_color "Enter your full name for Git:"
  read -r git_name
  git config --global user.name "$git_name"
  echo_color "Enter your Git mail:"
  read -r git_mail
  git config --global user.email "$git_mail"
  git config --global core.editor nano
  git config --global init.defaultBranch master

  # Generate SSH key for GitHub
  # Based on https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent
  echo_color "GitHub SSH setup..."
  echo_color "Enter GitHub mail (press ENTER if your would like to use Git mail):"
  read -r ssh_mail
  if [ -z "$ssh_mail" ]; then
    ssh_mail="$git_mail"
  fi
  ssh-keygen -t ed25519 -C "$ssh_mail"
  eval "$(ssh-agent -s)"
  ssh-add ~/.ssh/id_ed25519
  echo_color "Your SSH public key:"
  cat ~/.ssh/id_ed25519.pub
  echo_color "Copy SSH public key and add it to GitHub"
  echo "Press ENTER to continue..."
  read -rp "" # Pause

  echo_color "Do you want setup GPG key (Mark your commits as 'Verified' in GitHub)?"
  echo_color "press ENTER to skip, any input to continue like 'yes'"
  read -r gpg_option
  if [ -n "$gpg_option" ]; then
    # Generate GPG key for GitHub
    # Based on https://docs.github.com/en/authentication/managing-commit-signature-verification/generating-a-new-gpg-key
    echo_color "GitHub GPG setup..."
    gpg --default-new-key-algo rsa4096 --gen-key
    gpg_id="$(gpg --list-secret-keys --keyid-format=long | grep -o "rsa4096/.[A-Z0-9]* " | cut -d "/" -f2)"
    gpg_id="${gpg_id::-1}"
    gpg --armor --export "$gpg_id"
    git config --global user.signingkey "$gpg_id"
    git config --global commit.gpgsign true
    echo_color "Copy GPG public key and add it to GitHub"
    echo "Press ENTER to continue..."
    read -rp "" # Pause
  fi
}

function setup_nano() {
  find /usr/share/nano -maxdepth 2 -type f | sed "s/^/include /" >~/.nanorc
}

function setup_zsh() {
  cp ./.zshrc ~/.zshrc
  sudo curl https://raw.githubusercontent.com/Daivasmara/daivasmara.zsh-theme/master/daivasmara.zsh-theme | sudo tee "$ZSH_CUSTOM"/themes/daivasmara.zsh-theme
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

}

function setup_alacritty() {
  cp ./.alacritty.yml ~/.alacritty.yml
  sudo sed -i "s/^Exec=alacritty/Exec=env WAYLAND_DISPLAY= alacritty/g" /usr/share/applications/Alacritty.desktop
}

function setup_gnome() {
  # Settings
  gsettings set org.gnome.desktop.sound event-sounds false

  # Extensions
  # Manually install Vitals, Gnome 4x UI Improvements, Dash to Dock, Clipboard Indicator, Blur my Shell
}

function fix_varmilo() {
  echo "options hid_apple fnmode=2" | sudo tee /etc/modprobe.d/hid_apple.conf
  sudo dracut --force
}

while true; do
  clear
  echo -e "Choose options from top to bottom, DO NOT call the same option twice\n"
  echo "1) - Update system package managers and packages (Will cause system reboot) [Recommended]"
  echo "2) - Install Nvidia drivers (Will cause system reboot) [Recommended]"
  echo "3) - Install my set of packages (Will cause system reboot)"
  echo "4) - Setup Git"
  echo "5) - Setup nano syntax highlighting"
  echo "6) - Set my zsh setup"
  echo "7) - Set my alacritty setup and fix Wayland issue"
  echo "8) - Setup GNOME"
  echo "9) - Fix Varmilo keyboard F keys (Will cause system reboot)"
  echo "0) - Quit"

  read -r option
  case $option in
  1)
    dnf_update
    reboot
    ;;

  2)
    install_nvidia
    reboot
    ;;

  3)
    install_packages
    reboot
    ;;

  4)
    setup_git
    ;;

  5)
    setup_nano
    ;;

  6)
    setup_zsh
    ;;

  7)
    setup_alacritty
    ;;

  8)
    setup_gnome
    ;;

  9)
    fix_varmilo
    reboot
    ;;

  0)
    exit
    ;;

  esac
done
