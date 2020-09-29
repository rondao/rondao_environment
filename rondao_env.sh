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
  printf "[OK] "
  printf "\033[0;32m"
  echo   "$1"
  printf "\033[0m"
}

print_fail() {
  printf "\033[1;31m"
  printf "[FAIL] "
  printf "\033[0;31m"
  echo   "$1"
  printf "\033[0m"
}

print_in_green() {
  printf "\033[0;32m"
  echo   "     $1"
  printf "\033[0m"
}

print_in_red() {
  printf "\033[0;31m"
  echo   "       $1"
  printf "\033[0m"
}

print_title

# Apply GNOME settings
print_task "Apply GNOME settings."
if command -v gnome-shell > /dev/null 2>&1; then
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


