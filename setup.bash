#!/bin/bash

OS=$(grep '^ID=' /etc/os-release | cut -d'=' -f2)

FONT_DIR="$HOME/.local/share/fonts"
FONT_NAME="MesloLGS NF Regular.ttf"
FONT_URL="https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf"
NEW_PLUGINS="plugins=(git zsh-autosuggestions zsh-syntax-highlighting fast-syntax-highlighting)"

if [ $OS == "fedora" ]; then
    sudo dnf update -y
    sudo dnf install -y zsh neovim gh
else
    sudo apt update -y
    sudo apt install -y zsh neovim gh wget curl
fi

mkdir -p "$FONT_DIR"

wget -O "$FONT_DIR/$FONT_NAME" "$FONT_URL" || curl -o "$FONT_DIR/$FONT_NAME" "$FONT_URL"
fc-cache -f -v

PROFILE=$(gsettings get org.gnome.Terminal.ProfilesList default | tr -d \')

gsettings set org.gnome.desktop.interface monospace-font-name 'MesloLGS NF Regular 12'

if [ -n "$PROFILE" ]; then
    gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/Terminal/Legacy/Profiles:/:$PROFILE/" font 'MesloLGS NF Regular 12'
else
    echo "No default profile found"
fi

git clone https://github.com/S-Pushkar/nvim-configs.git ~/.config/nvim

# sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh
sh install.sh
# Type exit when the zsh shell opens, otherwise the rest of the script won't be executed

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# echo 'ZSH_THEME="powerlevel10k/powerlevel10k"' >> ~/.zshrc
if grep -q "^ZSH_THEME=" "$HOME/.zshrc"; then
    sed -i "s/^ZSH_THEME=.*/ZSH_THEME=\"powerlevel10k\/powerlevel10k\"/" "$HOME/.zshrc"
else
    echo 'ZSH_THEME="powerlevel10k/powerlevel10k"' >> "$HOME/.zshrc"
fi

git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting

if grep -q "^plugins=" "$HOME/.zshrc"; then
    sed -i "s/^plugins=.*/$NEW_PLUGINS/" "$HOME/.zshrc"
else
    echo "$NEW_PLUGINS" >> "$HOME/.zshrc"
fi

gh auth login
