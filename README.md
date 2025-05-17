# Linux SoundFixer VMs

**Linux Audio Solution for Virtual Machines**

<p align="center">
  <img src="resources\ic_SoundFixer.png" alt="SoundFixer Tool Icon" width="120" />
</p>

SoundFixer automates the installation and configuration of a modern audio stack (PipeWire) on Linux virtual machines. It resolves common audio issues—echo, no sound, glitches—often encountered in VM environments.

## Features

* Installs and configures PipeWire as the default audio server
* Installs essential audio client libraries and the GUI control panel (`pavucontrol`)
* Disables PulseAudio to prevent conflicts
* Enables and starts PipeWire services (`pipewire`, `pipewire-pulse`, `wireplumber`)
* Provides colored output and progress indicators
* Logs all actions to `~/SoundFixer.log`

## Prerequisites

* Debian/Ubuntu-based distribution (tested on Ubuntu, Debian)
* `sudo` privileges
* Terminal emulator (TTY detection for interactive mode)

## Installation

### Package Installation Options

#### Debian/Ubuntu (.deb)
```bash
wget https://github.com/SoufianoDev/Linux_SoundFixer/raw/refs/heads/main/releases/soundfixer.deb
sudo apt install ./soundfixer.deb
soundfixer
```

#### RPM-based (Fedora/RHEL/openSUSE)
```bash
wget https://github.com/SoufianoDev/Linux_SoundFixer/raw/refs/heads/main/releases/soundfixer-1.0-2.noarch.rpm
sudo dnf install ./soundfixer-1.0-2.noarch.rpm
soundfixer
```

#### Generic Linux (.tgz)
```bash
wget https://github.com/SoufianoDev/Linux_SoundFixer/raw/refs/heads/main/releases/soundfixer-1.0.tgz
tar xzf soundfixer-1.0.tgz
sudo cp -r usr/ /usr/
/usr/bin/soundfixer
```

### Direct Run (no install)
```bash
wget https://raw.githubusercontent.com/SoufianoDev/Linux_SoundFixer/refs/heads/main/main/SoundFixer.sh
chmod +x SoundFixer.sh
./SoundFixer.sh
```

### Source Installation Methods

#### Method 1: Clone and Run
```bash
mkdir -p ~/.local/bin/linux-soundfixer \
  && cd ~/.local/bin/linux-soundfixer \
&& curl -sLO https://raw.githubusercontent.com/SoufianoDev/Linux_SoundFixer/refs/heads/main/main/SoundFixer.sh \
  && chmod +x SoundFixer.sh \
  && ./SoundFixer.sh
```

#### Method 2: One-Line Install to ~/.local/bin
```bash
git clone https://github.com/SoufianoDev/Linux_SoundFixer.git
cd Linux_SoundFixer/main/
chmod +x SoundFixer.sh
./SoundFixer.sh
```

> After installation, you can run SoundFixer from anywhere:
> 
> ```bash
> ~/.local/bin/linux-soundfixer/SoundFixer.sh
> ```
> 
> Or add `~/.local/bin/linux-soundfixer` to your `PATH`:
> 
> ```bash
> echo 'export PATH="$HOME/.local/bin/linux-soundfixer:$PATH"' >> ~/.bashrc
> source ~/.bashrc
> ```

## Usage

* Interactive mode:

  ```bash
  ~/.local/bin/linux-soundfixer/SoundFixer.sh
  ```

* Automated/background mode (no TTY):

  ```bash
  bash ~/.local/bin/linux-soundfixer/SoundFixer.sh
  ```

  In non-TTY environments, the script runs silently and logs to `~/SoundFixer.log`.

## Logging

All output (stdout and stderr) is appended to:

```
~/SoundFixer.log
```

If errors occur, the log file is preserved for troubleshooting.

## Customization

* **Log file location**: Modify the `LOGFILE` variable in `SoundFixer.sh`.
* **Packages**: Edit the `install_audio_fix()` function to add or remove packages.
* **GitHub prompt**: Control interactive GitHub page opening via the `SHOW_GITHUB` variable.

## Contributing

Contributions welcome! Fork the repo, create a feature branch, commit, push, and open a PR. See [Contributor Covenant](https://www.contributor-covenant.org/) for code of conduct.

## License

This project is licensed under the [MIT License](https://github.com/SoufianoDev/Linux_SoundFixer/blob/main/LICENCE).

---

*Script by Soufiano Dev*
