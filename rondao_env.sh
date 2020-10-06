#!/bin/bash

APT_APPS_LIST=(
  git
  vim
  zsh
  code
  slack-desktop
  chromium
)

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
  printf "\u2611 "
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

install_with_apt() {
  if ! dpkg -s $1 >/dev/null 2>&1; then
    sudo apt -y install $1
    print_ok "$1 installed successfully."
  else
    print_warn "$1 was already installed"
  fi
}

install_apt_apps_list() {
  print_task "Install APT apps list"
  for app in ${APT_APPS_LIST[@]}; do
    print_in_green "Installing $app"
    install_with_apt $app
  done
}

install_interactive_dialog() {
  print_task "Install dialog for interactive mode"
  install_with_apt dialog
}

interactive_apt_apps_list() {
  print_task "Open interactive APT apps list"

  # dialog parameters = <tag1> <item1> <status1>...
  local dialog_parameters=()
  for app in ${APT_APPS_LIST[@]}; do
    dialog_parameters+=($app)
    dialog_parameters+=(".")
    dialog_parameters+=(on)
  done

  APT_APPS_LIST=()
  while IFS= read -r app; do
    APT_APPS_LIST+=($app)
  done <<< $(dialog --separate-output --checklist \
                    "APT apps to install" 0 0 10 ${dialog_parameters[@]} --output-fd 1)
}

configure_gnome_settings() {
  print_task "Configure GNOME settings"
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
}

configure_git() {
  print_task "Apply Git configurations"

  if command_exists git; then
    cp .gitconfig $HOME/
    print_ok "Git config file copied."
  else
    print_fail "Git is not installed."
  fi
}

install_and_configure_oh_my_zsh() {
  print_task "Install OhMyZsh"
  if ! test -d $HOME/.oh-my-zsh; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh) --unattended"
    print_ok "OhMyZsh was installed."
  else
    print_warn "OhMyZsh was already installed."
  fi

  print_task "Copy OhMyZsh config file"
  cp .zshrc $HOME/
  print_ok "OhMyZsh config file copied."
}

install_meslo_font() {
  print_task "Install Meslo Nerd Font"
  if ! test -f $HOME/.fonts/'MesloLGS NF Regular.ttf'; then
    wget -P $HOME/.fonts https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
  fi
  if ! test -f $HOME/.fonts/'MesloLGS NF Bold.ttf'; then
    wget -P $HOME/.fonts https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf
  fi
  if ! test -f $HOME/.fonts/'MesloLGS NF Italic.ttf'; then
    wget -P $HOME/.fonts https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
  fi
  if ! test -f $HOME/.fonts/'MesloLGS NF Bold Italic.ttf'; then
    wget -P $HOME/.fonts https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf
  fi
  print_ok "Meslo Nerd Font installed."
}

install_and_configure_powerlevel10k() {
  print_task "Install PowerLevel10K theme for OhMyZsh"
  if ! test -d $HOME/.oh-my-zsh/custom/themes/powerlevel10k; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
    print_ok "PowerLevel10K theme was installed."
  else
    print_warn "PowerLevel10K theme was already installed."
  fi

  print_task "Copy PowerLevel10K config file"
  cp .p10k.zsh $HOME/
  print_ok "PowerLevel10K config file copied."
}

install_nodejs() {
  print_task "Install NodeJS"
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.36.0/install.sh | bash
  print_ok "Node Version Manager installed."

  source $HOME/.bashrc
  nvm install node
  print_ok "NodeJS installed."

  npm install npm -g
  print_ok "NPM updated."
}

install_react_native() {
  print_task "Install React Native tools"
  if command_exists npm; then
    npm install -g expo-cli
    print_ok "Expo cli installed successfully."
  else
    print_ok "Expo cli failed to install."
  fi
}

configure_zsh_as_default_shell() {
  print_task "Change default shell to Zsh."
  if ! chsh -s `command -v zsh`; then
    print_fail "chsh command unsuccessful. Change your default shell manually."
  else
    export SHELL=`command -v zsh`
    print_ok "Shell successfully changed to Zsh."
  fi
}

parse_options() {
  while getopts "hi" opt; do
    case "$opt" in
    h)
      echo "Apply Rondão configurations and install apps."
      echo ""
      echo "  -i	Interactive Mode. May unselect apps to install."
      echo ""
      exit 0
      ;;
    i)
      INTERACTIVE=True
      ;;
    esac
  done
}

main() {
  parse_options "$@"

  print_title

  if [ -v INTERACTIVE ]; then
    install_interactive_dialog
    interactive_apt_apps_list
  fi

  configure_gnome_settings
  install_apt_apps_list
  install_nodejs
  install_react_native
  configure_git
  install_and_configure_oh_my_zsh
  install_meslo_font
  install_and_configure_powerlevel10k
  configure_zsh_as_default_shell

  print_warn "You need to change your Terminal font to Meslo manually."
}

main "$@"
