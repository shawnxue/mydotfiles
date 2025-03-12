#!/bin/sh

set -e

WHOAMI=$(whoami)
SPACEMACS_DIR="/Users/${WHOAMI}/.emacs.d"
OH_MY_ZSH_DIR="/Users/${WHOAMI}/.oh-my-zsh"
TMUX_TPM_DIR="/Users/${WHOAMI}/.tmux/plugins/tpm"

# install iTerm2, download it from https://iterm2.com/downloads.html

# Validate Homebrew is installed
if [ ! $(which brew) ]; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    # /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" (old)
fi

# Validate .oh-my-zsh is present
if [ ! -d ${OH_MY_ZSH_DIR} ]; then
    echo "Installing oh-my-zsh..."
    # git clone git://github.com/robbyrussell/oh-my-zsh.git ${OH_MY_ZSH_DIR} (this does not work)
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Validate .emacs.d is present if not clone spacemacs
if [ ! -d ${SPACEMACS_DIR} ]; then
    echo "Installing Spacemacs..."
    git clone https://github.com/syl20bnr/spacemacs ${SPACEMACS_DIR}
fi

# Validate TMUX TPM is present
if [ ! -d ${TMUX_TPM_DIR} ]; then
    echo "Installing tmux tpm..."
    git clone https://github.com/tmux-plugins/tpm ${TMUX_TPM_DIR}
fi

# download fonts, then run install.sh
git clone https://github.com/powerline/fonts.git
./font/install.sh

# setup oh my zash
# install PowerLevel10K
git clone https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k
# open $HOME/.zshrc, and add ZSH_THEME="powerlevel10k/powerlevel10k"
source $HOME/.zshrc
# install Meslo Nerd Font by running "p10k configure"

# Update VSCode Terminal Font (Optional) by adding these lines to $HOME/Library/Application Support/Code/User/settings.json
# "terminal.integrated.fontFamily": "MesloLGS NF"
# Configure PowerLevel10K

# config p10k, after that you can choose font size in iTerm2 profile
p10 configure

# Install zsh-syntax-highlighting:
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# edit $HOME/.zshrc and add this
# plugins=(git zsh-autosuggestions zsh-syntax-highlighting web-search)

source $HOME/.zshrc

# install kubectl
# install krew https://krew.sigs.k8s.io/docs/user-guide/setup/install/
# install ksniff: https://github.com/eldadru/ksniff
# set java home in .zshrc: export JAVA_HOME=`/usr/libexec/java_home`
echo "Installing all dotfiles"
/usr/bin/rake link

echo "Installing tmux plugins..."
bash $TMUX_TPM_DIR/bin/install_plugins

# Install Homebrew dependencies
echo "Installing all dependencies via Homebrew..."
/usr/local/bin/brew bundle install -v --global

# Set zsh as the default shell
chsh -s /bin/zsh

echo "Done."
