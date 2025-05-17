#!/bin/bash

# SoundFixer: Linux Audio Solution for Virtual Machines
# Author: Soufiano Dev
# GitHub: https://github.com/SoufianoDev
# Description: Fixes audio issues (echo, no sound) on Linux virtual machines

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m'

GITHUB_URL="https://github.com/SoufianoDev"
LOGFILE="$HOME/SoundFixer.log"
SUCCESS=true
SHOW_GITHUB=false

soundfixer_art() {
  echo -e "${GREEN}"
  echo "███████╗ ██████╗ ██╗   ██╗███╗   ██╗██████╗ ███████╗██╗██╗  ██╗███████╗██████╗ "
  echo "██╔════╝██╔═══██╗██║   ██║████╗  ██║██╔══██╗██╔════╝██║╚██╗██╔╝██╔════╝██╔══██╗"
  echo "███████╗██║   ██║██║   ██║██╔██╗ ██║██║  ██║█████╗  ██║ ╚███╔╝ █████╗  ██████╔╝"
  echo "╚════██║██║   ██║██║   ██║██║╚██╗██║██║  ██║██╔══╝  ██║ ██╔██╗ ██╔══╝  ██╔══██╗"
  echo "███████║╚██████╔╝╚██████╔╝██║ ╚████║██████╔╝██║     ██║██╔╝ ██╗███████╗██║  ██║"
  echo "╚══════╝ ╚═════╝  ╚═════╝ ╚═╝  ╚═══╝╚═════╝ ╚═╝     ╚═╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝"
  echo -e "${NC}"
  echo -e "${BLUE}             SoundFixer by Soufiano Dev${NC}"
  echo -e "${YELLOW}      Fixing audio issues on Linux virtual machines${NC}"
  echo
}

dev_name_art() {
  echo -e "${GREEN}"
  echo "███████╗ ██████╗ ██╗   ██╗███████╗██╗ █████╗ ███╗   ██╗ ██████╗ "
  echo "██╔════╝██╔═══██╗██║   ██║██╔════╝██║██╔══██╗████╗  ██║██╔═══██╗"
  echo "███████╗██║   ██║██║   ██║█████╗  ██║███████║██╔██╗ ██║██║   ██║"
  echo "╚════██║██║   ██║██║   ██║██╔══╝  ██║██╔══██║██║╚██╗██║██║   ██║"
  echo "███████║╚██████╔╝╚██████╔╝██║     ██║██║  ██║██║ ╚████║╚██████╔╝"
  echo "╚══════╝ ╚═════╝  ╚═════╝ ╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝ ╚═════╝ "
  echo -e "${NC}"
  echo "                    ██████╗ ███████╗██╗   ██╗                   "
  echo "                    ██╔══██╗██╔════╝██║   ██║                   "
  echo "                    ██║  ██║█████╗  ██║   ██║                   "
  echo "                    ██║  ██║██╔══╝  ╚██╗ ██╔╝                   "
  echo "                    ██████╔╝███████╗ ╚████╔╝                    "
  echo "                    ╚═════╝ ╚══════╝  ╚═══╝                     "
  echo
}

github_ascii_art() {
  echo -e "${PURPLE}"
  echo " ██████╗ ██╗████████╗██╗  ██╗██╗   ██╗██████╗ "
  echo "██╔════╝ ██║╚══██╔══╝██║  ██║██║   ██║██╔══██╗"
  echo "██║  ███╗██║   ██║   ███████║██║   ██║██████╔╝"
  echo "██║   ██║██║   ██║   ██╔══██║██║   ██║██╔══██╗"
  echo "╚██████╔╝██║   ██║   ██║  ██║╚██████╔╝██████╔╝"
  echo " ╚═════╝ ╚═╝   ╚═╝   ╚═╝  ╚═╝ ╚═════╝ ╚═════╝ "
  echo -e "${NC}"
}

show_progress() {
    local -r pid="${1}"
    local -r delay=0.75
    local spinstr='|/-\'
    local temp
    while ps a | awk '{print $1}' | grep -q "${pid}"; do
        temp="${spinstr#?}"
        printf " [%c]  " "${spinstr}"
        spinstr=${temp}${spinstr%"${temp}"}
        sleep "${delay}"
        printf "\b\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
}

run_silent() {
    local cmd="$@"
    $cmd >> "$LOGFILE" 2>&1 &
    local pid=$!
    show_progress $pid
    wait $pid
    return $?
}

cleanup() {
  if $SUCCESS; then
    rm -f "$LOGFILE"
  else
    echo -e "${RED}Installation encountered errors. Log file kept at: $LOGFILE${NC}"
    echo -e "${YELLOW}Please check the log file and report any issues at: ${GITHUB_URL}${NC}"
  fi
}

open_github_once() {
  if $SHOW_GITHUB; then
    if command -v xdg-open >/dev/null 2>&1; then
      xdg-open "$GITHUB_URL" >/dev/null 2>&1 &
    elif command -v gnome-open >/dev/null 2>&1; then
      gnome-open "$GITHUB_URL" >/dev/null 2>&1 &
    fi
  fi
}

# Main installation function
install_audio_fix() {
  # Step 1: Update packages
  echo -ne "${YELLOW}Updating package list...${NC}"
  if run_silent sudo apt-get update -qq; then
    echo -e "${GREEN} Done${NC}"
  else
    SUCCESS=false
    echo -e "${RED} Failed${NC}"
    return 1
  fi

  # Step 2: Install PipeWire
  echo -ne "${YELLOW}Configuring audio server...${NC}"
  if run_silent sudo apt-get install -y pipewire; then
    echo -e "${GREEN} Done${NC}"
  else
    SUCCESS=false
    echo -e "${RED} Failed${NC}"
    return 1
  fi

  # Step 3: Install audio libraries
  echo -ne "${YELLOW}Installing audio components...${NC}"
  if run_silent sudo apt-get install -y pipewire-audio-client-libraries; then
    echo -e "${GREEN} Done${NC}"
  else
    SUCCESS=false
    echo -e "${RED} Failed${NC}"
    return 1
  fi

  # Step 4: Install control panel
  echo -ne "${YELLOW}Setting up control panel...${NC}"
  if run_silent sudo apt-get install -y pavucontrol; then
    echo -e "${GREEN} Done${NC}"
  else
    SUCCESS=false
    echo -e "${RED} Failed${NC}"
    return 1
  fi

  # Step 5: Disable PulseAudio
  echo -ne "${YELLOW}Optimizing audio configuration...${NC}"
  if run_silent sudo systemctl --global mask pulseaudio.socket pulseaudio.service; then
    echo -e "${GREEN} Done${NC}"
  else
    SUCCESS=false
    echo -e "${RED} Failed${NC}"
    return 1
  fi

  # Step 6: Enable PipeWire
  echo -ne "${YELLOW}Activating new audio system...${NC}"
  if run_silent systemctl --user enable --now pipewire pipewire-pulse wireplumber; then
    echo -e "${GREEN} Done${NC}"
  else
    SUCCESS=false
    echo -e "${RED} Failed${NC}"
    return 1
  fi

  # Step 7: Start control panel
  echo -ne "${YELLOW}Finalizing setup...${NC}"
  if ! pgrep pavucontrol > /dev/null; then
    nohup pavucontrol >/dev/null 2>&1 &
    disown
  fi
  echo -e "${GREEN} Done${NC}"
  
  return 0
}

# Run in foreground if terminal is visible
if [ -t 1 ]; then
  SHOW_GITHUB=true
  soundfixer_art
  echo -e "${BLUE}This tool will optimize your Linux audio system${NC}"
  echo -e "${YELLOW}Note: This may take a few minutes. Please wait...${NC}"
  echo

  install_audio_fix

  if $SUCCESS; then
    echo -e "${GREEN}Audio system optimization completed successfully!${NC}"
    
    # Display farewell with developer info
    echo
    echo -e "${BLUE}Thank you for using SoundFixer!${NC}"
    dev_name_art
    echo -e "${YELLOW}For more information, visit:${NC}"
    github_ascii_art
    echo -e "${BLUE}${GITHUB_URL}${NC}"
    
    # Open GitHub page once if running manually
    open_github_once
    
    echo -e "\n${YELLOW}Press any key to exit...${NC}"
    read -n 1 -s -r
  else
    echo -e "${RED}Audio optimization failed. See log file for details.${NC}"
  fi

  cleanup
  exit 0
else
  # Run in background if not in terminal
  SHOW_GITHUB=false
  install_audio_fix
  cleanup
  exit 0
fi

# --- Auto-start setup section ---
setup_autostart() {
  AUTOSTART_SERVICE="$HOME/.config/systemd/user/soundfixer.service"
  mkdir -p "$HOME/.config/systemd/user"
  cat > "$AUTOSTART_SERVICE" <<EOF
[Unit]
Description=SoundFixer Auto Start

[Service]
Type=simple
ExecStart=$PWD/$(basename "$0")
Restart=on-failure

[Install]
WantedBy=default.target
EOF

  systemctl --user daemon-reload
  systemctl --user enable --now soundfixer.service
}

# Only set up autostart if not already enabled and running in a user session
if [ -n "$XDG_SESSION_TYPE" ] && [ ! -f "$HOME/.config/systemd/user/soundfixer.service" ]; then
  setup_autostart
fi