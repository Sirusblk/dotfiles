#!/bin/bash

# List of Apps & Fonts
binaries=(
    boost
    dasm
    docker
    doxygen
    editorconfig
    ffmpeg
    findutils
    flac
    gcc
    gdb
    git
    glew
    glfw
    grep
    imagemagick
    kotlin
    nvm
    pandoc
    screenfetch
    sqlite
    # Need svn to brew install many fonts
    svn
    tmux
    tree
    wget
    vim
    zsh-syntax-highlighting
)

apps=(
    bit-slicer
    discord
    google-drive
    iterm2
    rectangle
)

fonts=(
    font-alice
    font-cabin
    font-coda
    font-comic-neue
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
install_homebrew()
{
    # Check for Homebrew,
    # Install if we don't have it
    if test ! $(which brew); then
        echo "Installing homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
}

install_coreutils()
{
    # Update $Path for updated unix tools
    echo "Installing coreutils..."
    brew install coreutils
}

install_brew_binaries()
{
    echo "Installing binaries..."
    brew install ${binaries[@]}
}

install_brew_casks()
{
    # Install apps to /Applications
    echo "Installing apps..."
    brew install --cask ${apps[@]}
}

install_brew_fonts()
{
    brew tap homebrew/cask-fonts
    echo "Installing fonts..."
    brew install --cask ${fonts[@]}

    # Install powerline fonts
    git clone https://github.com/powerline/fonts.git
    sh fonts/install.sh
    rm -rf fonts
}

install_oh_my_zsh()
{
    echo "Installing oh-my-zsh"
    # Specify & to run in background, we'll switch shells later
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" &
}

install_opengl()
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

setup_extras()
{
    echo "Seting up extras..."
    mkdir ~/Code
    mkdir ~/Books

    # Don't worry, we'll replace with our own later
    rm ~/.editorconfig
    rm ~/.vimrc
    rm ~/.zshrc

    # Set up VIM
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    vim +PluginInstall +qall

    # Symlink dotfiles
    ln -s $HOME/dotfiles/.editorconfig ~/.editorconfig
    ln -s $HOME/dotfiles/.vimrc ~/.vimrc
    ln -s $HOME/dotfiles/.zshrc ~/.zshrc
}

setup_mac_specific()
{
    # Set up Base16 Shell
    git clone https://github.com/chriskempson/base16-shell.git ~/.config/base16-shell

    echo ""
    echo ""
    echo "Setup your shell colors with:"
    echo ""
    echo "\tbase16_eighties"
    echo ""
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
install_coreutils
install_brew_binaries
install_brew_casks
install_brew_fonts
install_oh_my_zsh
setup_extras
setup_mac_specific

# Cleanup afterwards
brew cleanup

# Final Output messages
echo ""
echo ""
echo "...done"
