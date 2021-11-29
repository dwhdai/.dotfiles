# Install homebrew if needed
mkdir homebrew && curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C homebrew

# Install kitty terminal
brew install --cask kitty 

# Install zsh and Antibody plugin manager
brew install zsh
curl -sfL git.io/antibody | sh -s - -b /usr/local/bin

# Install font
brew tap homebrew/cask-fonts         
brew install font-jetbrains-mono-nerd-font

# Install neovim
brew install neovim

# Install vim plug
sh -c 'curl -fLo $HOME/.local/share/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

# Install stow
brew install stow

# Stow dotfiles
stow nvim
stow zsh
# Use kitty terminal on mac
[ `uname -s` = 'Darwin' ] && stow kitty

# Add zsh as a login shell
command -v zsh | sudo tee -a /etc/shells

# Set zsh as default shell
sudo chsh -s $(which zsh) $USER

# Install neovim plugins
nvim --headless +PlugInstall +qall

# Other utilities
brew install ripgrep
