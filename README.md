# My Linux Setup Script

## Information

This repository provides a shell script to install and configure the following on a new Linux install:

- **Zsh** + **Oh My Zsh**
- **Powerlevel10k** theme
- **Zsh Plugins:** (autosuggestions, syntax-highlighting)
- **Neovim** (using my [S-Pushkar/nvim-configs](https://github.com/S-Pushkar/nvim-configs))
- **Colorls** (a modern `ls` alternative with icons)
- **MesloLGS NF** font (for Powerlevel10k)
- **GitHub CLI** (`gh`)
- **Common GNOME Shell Extensions** (if a GNOME desktop is detected)

The script automatically detects the OS and uses the correct package manager for **Fedora**, **Arch Linux**, and **Ubuntu/Debian-based** distributions.

## Installation

1.  Clone this repository or download the `setup.bash` file.
2.  Run the script:
    ```bash
    ./setup.bash
    ```

## Post-Installation Steps

The script will run automatically but requires two manual interactions:

1.  **Sudo Password:** You will be prompted for your user password to install system packages.
2.  **GitHub Login:** At the very end, the script runs `gh auth login`. Follow the prompts to authenticate.
    - Select `GitHub.com` and press enter.
    - Select `HTTPS` and press enter.
    - When asked `Authenticate Git with your GitHub credentials?`, type `y` and press enter.
    - Select `Login with a web browser` and press enter.
    - Copy the one-time code, press enter, and paste the code into the browser window that opens.

### 🔴 Final (Important) Step

After the script finishes, you **must log out and log back in** (or reboot your computer).

This is required for all changes to take full effect, including:

- Setting Zsh as your default shell.
- Loading the newly installed fonts.
- Activating the GNOME extensions.
