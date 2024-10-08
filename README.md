# Information

- This repository provides a shell script to install and configure the following in Fedora or Ubuntu(Debian based):
    - Neovim
    - Zsh
    - MesloLGS NF font for the terminal
    - Oh-My-Zsh
    - Powerlevel10k
    - gh (To instantly start using git)

- If you want to use this script in a distribution which does not use ```dnf``` or ```apt``` package manager, change the script as needed.

# Installation

```./setup.bash```

# Additional Information

- When asked ```Do you want to change your default shell to zsh?```, type ```y``` and press enter.
- After the above step, the zsh terminal will open. Type ```exit``` and press enter to close the terminal and continue with the installation.
- At the end of the installation, you will be prompted to login to github(gh auth login).
    - Select ```GitHub.com``` and press enter.
    - Select ```HTTPS``` and press enter.
    - When asked ```Authenticate Git with your GitHub credentials?```, type ```y``` and press enter.
    - When asked ```How would you like to authenticate GitHub CLI?```, select ```Login with a web browser``` and press enter.
    - Copy the one-time code and press enter.
    - A browser window will open asking you to paste the one-time code. Paste the code and press enter.
    - You are done with the installation.
