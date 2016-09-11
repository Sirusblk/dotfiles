#!/bin/bash

# Adapted from LapwingLabs
# http://lapwinglabs.com/blog/hacker-guide-to-setting-up-your-mac

# List of Apps & Fonts
binaries=(
    bash
    boost
    caskroom/cask/brew-cask
    cabextract
    docker
    git
    glew
    gmp
    macvim
    mercurial
    node
    pandoc
    python
    python3
    screenfetch
    tmux
    wget
    zsh
)

apps=(
    atom
    cheatsheet
    dropbox
    google-chrome
    google-drive
    iterm2
    screenfetch
    slack
    spectacle
    sublime-text3
    vagrant
    virtualbox
    wget
    zsh
)

fonts=(
    font-alice
    font-cabin
    font-coda
    font-comic-neue
    font-hack
    font-impact
    font-inconsolata-dz-for-powerline
    font-inconsolata-dz
    font-keep-calm
    font-lobster
    font-lobster-two
    font-meslo
    font-montserrat
    font-ocra
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
    font-trebuchet-ms
    font-ubuntu-mono-powerline
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
    brew update
}

function update_unix_tools()
{
    # Install GNU core utilities (those that come with OS X are outdated)
    brew install coreutils

    # Install GNU `find`, `locate`, `updatedb`, and `xargs`, g-prefixed
    brew install findutils

    # Install Bash 4
    brew install bash

    # Install more recent versions of some OS X tools
    brew tap homebrew/dupes
    brew install homebrew/dupes/grep

    # Update $Path for updated unix tools
    $PATH=$(brew --prefix coreutils)/libexec/gnubin:$PATH
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

    # A special case where we would prefer macvim,
    # so we have to link it in manually.
    brew linkapps macvim
}

function install_fonts()
{
    echo "Installing fonts..."
    brew cask install ${fonts[@]}
}

function install_zsh()
{
    echo "Installing oh-my-zsh"
    curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | sh

    # Syntax Highlighting
    mkdir -p ~/.oh-my-zsh/custom/plugins
    cd ~/.oh-my-zsh/custom/plugins
    git clone git://github.com/zsh-users/zsh-syntax-highlighting.git
    cd ~
}

function install_python_libraries()
{
    pip install -r requirements.txt
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
    git clone https://github.com/chriskempson/base16-shell.git
    ~/.config/base16-shell

    # Set up VIM
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    vim +PluginInstall +qall

    # Install powerline fonts
    git clone https://github.com/powerline/fonts.git
    cd fonts
    sh install.sh
    cd ..
    rm -rf fonts
}

# Main
clear
sudo -v

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

echo "...done"
