#!/bin/bash

print_title() {
  printf "\033[1;36m"
  echo ""
  echo " ╔══════════════════════════════╗"
  echo " ┃   Rondão Linux Environment   ┃"
  echo " ╚══════════════════════════════╝"
  echo ""
  printf "\033[0m"
}

print_task() {
  printf "\033[1;36m"
  printf "[TASK] "
  printf "\033[0;36m"
  echo   "$1"
  printf "\033[0m"
}

print_ok() {
  printf "\033[1;32m"
  printf "\u2611 "
  printf "\033[0;32m"
  printf "$1\n"
  printf "\033[0m"
}

print_fail() {
  printf "\033[1;31m"
  printf "\u2612 "
  printf "\033[0;31m"
  printf "$1\n"
  printf "\033[0m"
}

print_warn() {
  printf "\033[1;33m"
  printf "\u2612 "
  printf "\033[0;33m"
  printf "$1\n"
  printf "\033[0m"
}


print_in_green() {
  printf "\033[0;32m"
  printf "\u21AA $1\n"
  printf "\033[0m"
}

print_in_red() {
  printf "\033[0;31m"
  printf "\u21AA $1\n"
  printf "\033[0m"
}

command_exists() {
  command -v "$@" >/dev/null 2>&1
}

print_title


print_task "Apply GNOME settings"
if command_exists gnome-shell; then
  if command -v dconf > /dev/null 2>&1; then
    if test -f dconf-gnome.ini; then
      dconf load / < dconf-gnome.ini
      print_ok "GNOME settings applied."
    else
      print_fail "dconf-gnome.ini file not found."
      print_in_red "Skip GNOME settings."
    fi
  else
    print_fail "dconf command not found."
    print_in_red "Skip GNOME settings."
  fi
else
  print_fail "gnome-shell command not found."
  print_in_red "Skip GNOME settings."
fi

print_task "Apply Git identity"
if command_exists git; then
  git config --global user.email "rafael.rondao@gmail.com"
  git config --global user.name "Rafael Rondao"
  print_ok "Git identity applied."
else
  print_fail "Git is not installed."
fi

print_task "Install Zsh"
if ! command_exists zsh; then
  sudo apt -y install zsh
  if command_exists zsh; then
    print_ok "ZSH was installed."
  else
    print_fail "ZSH failed to install."
  fi
else
  print_ok "ZSH is already installed."
fi

print_task "Install OhMyZsh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh) --unattended"
print_ok "OhMyZsh was installed."

print_task "Copy OhMyZsh config file"
cp .zshrc $HOME/
print_ok "OhMyZsh config file copied."

print_task "Install Meslo Nerd Font"
wget -P ~/.fonts https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
wget -P ~/.fonts https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf
wget -P ~/.fonts https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
wget -P ~/.fonts https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf
print_ok "Meslo Nerd Font installed."

print_task "Install PowerLevel10K theme for OhMyZsh"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
print_ok "PowerLevel10K theme installed."

print_task "Copy PowerLevel10K config file"
cp .p10k.zsh $HOME/
print_ok "PowerLevel10K config file copied."


print_task "Change default shell to Zsh."
if ! chsh -s command -v zsh; then
  print_fail "chsh command unsuccessful. Change your default shell manually."
else
  export SHELL=`command -v zsh`
  print_ok "Shell successfully changed to Zsh."
fi

print_warn "You need to change your Terminal font to Meslo manually."
