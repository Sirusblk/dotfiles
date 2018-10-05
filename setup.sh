#!/bin/bash

# Adapted from LapwingLabs
# http://lapwinglabs.com/blog/hacker-guide-to-setting-up-your-mac

# List of Apps & Fonts
binaries=(
    bash
    boost
    cabextract
    coreutils
    dasm
    docker
    doxygen
    editorconfig
    emacs
    ffmpeg
    findutils
    flac
    freeimage
    gcc
    gdb
    git
    glew
    glfw
    grep
    hugo
    imagemagick
    kotlin
    macvim
    mercurial
    node
    pandoc
    python
    python3
    screenfetch
    sqlite
    tmux
    tree
    wget
    vim
    zsh
)

apps=(
    atom
    bit-slicer
    cheatsheet
    coda
    discord
    dropbox
    emacs
    flux
    google-backup-and-sync
    google-chrome
    googleappengine
    iterm2
    java
    macdown
    meld
    slack
    spectacle
    stella
    sublime-text
    transmit
    vagrant
    virtualbox
)

fonts=(
    font-alice
    font-cabin
    font-coda
    font-comic-neue
    font-inconsolata-dz
    font-lobster
    font-lobster-two
    font-meslo-for-powerline
    font-montserrat
    font-ocr
    font-open-sans
    font-oxygen
    font-permanent-marker
    font-pt-mono
    font-pt-sans
    font-pt-serif
    font-quantico
    font-raleway
    font-roboto
    font-sacramento
    font-salsa
    font-source-code-pro
    font-tangerine
    font-terminus
    font-titan-one
    font-ubuntu
    font-underdog
    font-unica-one
    font-voltaire
    font-yellowtail
)

#############
# Functions #
#############
function install_homebrew()
{
    # Check for Homebrew,
    # Install if we don't have it
    if test ! $(which brew); then
        echo "Installing homebrew..."
        ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    fi

    # Update homebrew recipes
    echo "Updating homebrew..."
    brew update
}

function update_unix_tools()
{
    # Update $Path for updated unix toolsi
    echo "Setting coreutils..."
    PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
}

function install_brew_binaries()
{
    echo "Installing binaries..."
    brew install ${binaries[@]}
}

function install_brew_casks()
{
    # Install apps to /Applications
    # Default is: /Users/$user/Applications
    echo "Installing apps..."
    brew cask install --appdir="/Applications" ${apps[@]}
}

function install_fonts()
{
    brew tap homebrew/cask-fonts
    echo "Installing fonts..."
    brew cask install ${fonts[@]}
}

function install_zsh()
{
    echo "Installing oh-my-zsh"
    cd ~
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" &
    cd -

    # Syntax Highlighting
    mkdir -p ~/.oh-my-zsh/custom/plugins
    cd ~/.oh-my-zsh/custom/plugins
    git clone git://github.com/zsh-users/zsh-syntax-highlighting.git
    cd ~
}

function install_python_libraries()
{
    echo "Installing python libraries..."
    pip install -r $HOME/dotfiles/python/requirements.txt
}

function install_opengl()
{
    echo "Installing OpenGL Dev Tools"
    brew tap homebrew/versions
    brew install glfw3 pkg-config
    cd ~
    git clone http://github.com/patriciogonzalezvivo/glslViewer
    cd glslViewer
    make
    make install
}

function setup_extras()
{
    echo "Seting up extras..."
    mkdir ~/Code
    mkdir ~/Books

    # Set up ZSH as default shell
    echo "/usr/local/bin/zsh" | sudo tee -a /etc/shells

    # Symlink dotfiles
    ln -s $HOME/dotfiles/.editorconfig ~/.editorconfig
    ln -s $HOME/dotfiles/.vimrc ~/.vimrc
    ln -s $HOME/dotfiles/.zshrc ~/.zshrc

    # Set up Base16 Shell
    git clone https://github.com/martinlindhe/base16-iterm2.git ~/base16-shell

    # Set up VIM
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    vim +PluginInstall +qall

    # Install powerline fonts
    git clone https://github.com/powerline/fonts.git
    cd fonts
    sh install.sh
    cd ..
    rm -rf fonts

    # Add ssh key settings
    cp $HOME/dotfile/ssh/config $HOME/.ssh/config
    ssh-add -K ~/.ssh/id_rsa
}

# Main
clear

# Ask for password first
sudo -v &> /dev/null

# Update sudo ahead of 5 minute timeout
while true; do
    sudo -n true
    sleep 240
    kill -0 "$$" || exit
done &> /dev/null &

install_homebrew
update_unix_tools
install_brew_binaries
install_brew_casks
install_fonts
install_zsh
install_python_libraries
setup_extras

# Cleanup afterwards
brew cleanup

# Final Output messages
echo "Don't forget to change shells with:"
echo ""
echo "\tchsh -s $(which zsh)"
echo ""
echo "Then setup your shell colors with:"
echo ""
echo "base16-monokai"
echo ""
echo "...done"
