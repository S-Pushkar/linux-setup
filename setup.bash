#!/bin/bash

echo "--- Starting Dotfile Setup ---"

# -----------------------------------------------------------------------------
# Configuration
# -----------------------------------------------------------------------------
OS=$(grep '^ID=' /etc/os-release | cut -d'=' -f2)

FONT_DIR="$HOME/.local/share/fonts"
FONT_NAME="MesloLGS NF Regular.ttf"
FONT_URL="https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf"
NEW_PLUGINS="plugins=(git zsh-autosuggestions zsh-syntax-highlighting fast-syntax-highlighting)"

GNOME_EXTENSIONS=(
    "3193"  # blur-my-shell@aunetx
    "4679"  # burn-my-windows@schneegans.github.com
    "779"   # clipboard-indicator@tudmotu.com
    "3740"  # compiz-alike-magic-lamp-effect@hermes83.github.com
    "3210"  # compiz-windows-effect@hermes83.github.com
    "307"   # dash-to-dock@micxgx.gmail.com
    "4648"  # desktop-cube@schneegans.github.com
    "2087"  # ding@rastersoft.com (Desktop Icons NG)
)


# -----------------------------------------------------------------------------
# 1. Install System Packages
# -----------------------------------------------------------------------------
echo "Running system package installation for OS: $OS"

if [ $OS == "fedora" ]; then
    sudo dnf update -y
    sudo dnf install -y zsh neovim gh ruby-devel gcc make wget curl gnome-extensions-app
elif [ $OS == "arch" ]; then
    sudo pacman -Syu
    sudo pacman -S --noconfirm zsh neovim github-cli wget curl ruby gnome-shell-extensions
else
    sudo apt update -y
    sudo apt install -y zsh neovim gh wget curl ruby-full gnome-shell-extensions
fi


# -----------------------------------------------------------------------------
# 2. Install Colorls
# -----------------------------------------------------------------------------
echo "Installing colorls..."
gem install colorls

echo "Configuring colorls tab completion for Zsh..."
echo "" >> ~/.zshrc
echo "# Add colorls tab completion (loads path dynamically)" >> ~/.zshrc
echo 'source $(dirname $(gem which colorls 2>/dev/null))/tab_complete.sh' >> ~/.zshrc

echo "Adding 'ls' alias to .zshrc and .bashrc..."
echo "alias ls=colorls" >> ~/.zshrc
echo "alias ls=colorls" >> ~/.bashrc


# -----------------------------------------------------------------------------
# 3. Install Nerd Font
# -----------------------------------------------------------------------------
echo "Installing MesloLGS NF font..."
mkdir -p "$FONT_DIR"

if command -v wget &> /dev/null; then
    wget -O "$FONT_DIR/$FONT_NAME" "$FONT_URL"
else
    curl -o "$FONT_DIR/$FONT_NAME" "$FONT_URL"
fi

echo "Updating font cache..."
fc-cache -f -v


# -----------------------------------------------------------------------------
# 4. Configure GNOME (Fonts & Extensions)
# -----------------------------------------------------------------------------
if [[ "$XDG_CURRENT_DESKTOP" == *"GNOME"* ]]; then
  echo "✅ GNOME Desktop detected. Applying settings..."

  # Set terminal and system fonts
  echo "Setting monospace font to MesloLGS NF..."
  
  # --- FIX 1: Use 'Legacy' path for 'get' command ---
  PROFILE=$(gsettings get org.gnome.Terminal.Legacy.ProfilesList default | tr -d \')
  
  gsettings set org.gnome.desktop.interface monospace-font-name 'MesloLGS NF Regular 12'

  if [ -n "$PROFILE" ]; then
      gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/Terminal/Legacy/Profiles:/:$PROFILE/" font 'MesloLGS NF Regular 12'
  else
      echo "No default GNOME Terminal profile found, skipping terminal font."
  fi

  # --- Install Extensions ---
  
  echo "Downloading gnome-shell-extension-installer..."
  wget -O gnome-shell-extension-installer "https://github.com/brunelli/gnome-shell-extension-installer/raw/master/gnome-shell-extension-installer"
  chmod +x gnome-shell-extension-installer
  
  echo "Installing and enabling GNOME extensions..."
  for extension_id in "${GNOME_EXTENSIONS[@]}"; do
    echo "Processing $extension_id..."
    
    # Use the script to install AND enable.
    ./gnome-shell-extension-installer "$extension_id" --yes || true
    
    # --- FIX 2: REMOVED the 'gnome-extensions enable' line that was causing errors ---
    
  done
  
  rm gnome-shell-extension-installer

  echo "🎉 GNOME extension setup complete."
  echo "   Note: You may need to log out and back in for all extensions to load."
  
else
  echo "ℹ️ Not a GNOME Desktop ($XDG_CURRENT_DESKTOP). Skipping GNOME configuration."
fi

# -----------------------------------------------------------------------------
# 5. Install Neovim Config
# -----------------------------------------------------------------------------
echo "Cloning Neovim config..."
git clone https://github.com/S-Pushkar/nvim-configs.git ~/.config/nvim


# -----------------------------------------------------------------------------
# 6. Install Oh My Zsh (Non-interactively)
# -----------------------------------------------------------------------------
echo "Installing Oh My Zsh (non-interactive)..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended


# -----------------------------------------------------------------------------
# 7. Install Zsh Theme & Plugins (This will run now!)
# -----------------------------------------------------------------------------
echo "Installing Powerlevel10k theme..."
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

echo "Setting ZSH_THEME in .zshrc..."
if grep -q "^ZSH_THEME=" "$HOME/.zshrc"; then
    sed -i "s/^ZSH_THEME=.*/ZSH_THEME=\"powerlevel10k\/powerlevel10k\"/" "$HOME/.zshrc"
else
    echo 'ZSH_THEME="powerlevel10k/powerlevel10k"' >> "$HOME/.zshrc"
fi

echo "Installing Zsh plugins (autosuggestions, syntax-highlighting)..."
git clone https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting

echo "Setting plugins in .zshrc..."
if grep -q "^plugins=" "$HOME/.zshrc"; then
    sed -i "s/^plugins=.*/$NEW_PLUGINS/" "$HOME/.zshrc"
else
    echo "$NEW_PLUGINS" >> "$HOME/.zshrc"
fi


# -----------------------------------------------------------------------------
# 8. Final Manual Steps
# -----------------------------------------------------------------------------
echo ""
echo "--- ✅ Setup Complete! ---"
echo "You may need to log out or reboot for all changes (fonts, extensions) to apply."
echo "Finally, please run 'gh auth login' manually."

gh auth login
