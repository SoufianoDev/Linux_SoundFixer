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

# Function to launch pavucontrol and ensure it's visible
launch_pavucontrol() {
  # Close any existing instances
  pkill pavucontrol

  # Wait a moment to ensure previous instances are closed
  sleep 1
  
  # Start pavucontrol with window focus (using different methods for compatibility)
  if command -v wmctrl >/dev/null 2>&1; then
    # Launch pavucontrol
    pavucontrol >/dev/null 2>&1 &
    PAVUCONTROL_PID=$!
    
    # Wait for window to appear then focus it
    sleep 2
    wmctrl -a "Volume Control" >/dev/null 2>&1
  else
    # If wmctrl not available, try basic approach
    pavucontrol >/dev/null 2>&1 &
    PAVUCONTROL_PID=$!
  fi
  
  # Ensure process continues in background
  disown $PAVUCONTROL_PID
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
  if run_silent sudo apt-get install -y pavucontrol wmctrl; then
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

  # Step 7: Launch audio control panel
  echo -ne "${YELLOW}Launching audio control panel...${NC}"
  launch_pavucontrol
  echo -e "${GREEN} Done${NC}"
  
  return 0
}

# Setup autostart for both the script and pavucontrol
setup_autostart() {
  # Create necessary directories
  mkdir -p "$HOME/.config/systemd/user"
  mkdir -p "$HOME/.config/autostart"
  
  # 1. Create systemd user service for SoundFixer
  AUTOSTART_SERVICE="$HOME/.config/systemd/user/soundfixer.service"
  cat > "$AUTOSTART_SERVICE" <<EOF
[Unit]
Description=SoundFixer Audio System
After=graphical-session.target
PartOf=graphical-session.target

[Service]
Type=oneshot
ExecStart=$(readlink -f "$0")
RemainAfterExit=true

[Install]
WantedBy=graphical-session.target
EOF

  # 2. Create desktop entry for pavucontrol
  PAVUCONTROL_DESKTOP="$HOME/.config/autostart/soundfixer-pavucontrol.desktop"
  cat > "$PAVUCONTROL_DESKTOP" <<EOF
[Desktop Entry]
Type=Application
Name=SoundFixer Audio Panel
Exec=pavucontrol
Icon=pavucontrol
Comment=Audio Control Panel for SoundFixer
X-GNOME-Autostart-enabled=true
X-KDE-autostart-after=plasma-workspace
Categories=AudioVideo;Audio;Mixer;
Terminal=false
StartupNotify=true
StartupWMClass=pavucontrol
EOF

  # Make the desktop file executable
  chmod +x "$PAVUCONTROL_DESKTOP"

  # Enable the systemd service
  systemctl --user daemon-reload
  systemctl --user enable soundfixer.service
  
  echo -e "${GREEN}Autostart configured successfully!${NC}"
}

# Run in foreground if terminal is visible
if [ -t 1 ]; then
  SHOW_GITHUB=true
  soundfixer_art
  echo -e "${BLUE}This tool will optimize your Linux audio system${NC}"
  echo -e "${YELLOW}Note: This may take a few minutes. Please wait...${NC}"
  echo

  install_audio_fix
  
  # Always set up autostart for future boots
  echo -ne "${YELLOW}Configuring autostart at boot...${NC}"
  setup_autostart
  echo -e "${GREEN} Done${NC}"

  if $SUCCESS; then
    echo -e "${GREEN}Audio system optimization completed successfully!${NC}"
    echo -e "${GREEN}The audio control panel will now open automatically at each system startup.${NC}"
    
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
  setup_autostart
  cleanup
  exit 0
fi