sudo apt update

# Install stow
sudo apt -y install stow

# Install Neovim

# first need to fix some broken dependencies on Ubuntu 18.04?
wget http://mirrors.edge.kernel.org/ubuntu/pool/main/g/gcc-10/gcc-10-base_10-20200411-0ubuntu1_amd64.deb
sudo apt install ./gcc-10-base_10-20200411-0ubuntu1_amd64.deb

wget http://mirrors.xmission.com/ubuntu/pool/main/g/gcc-10/libgcc-s1_10-20200411-0ubuntu1_amd64.deb
sudo apt install ./libgcc-s1_10-20200411-0ubuntu1_amd64.deb

wget https://github.com/neovim/neovim/releases/download/v0.7.0/nvim-linux64.deb
sudo apt install ./nvim-linux64.deb

# Install zsh and set as default shell
sudo apt -y install zsh
sudo sed s/required/sufficient/g -i /etc/pam.d/chsh
chsh -s $(which zsh)

# Install antibody - zsh plugin manager
curl -sfL git.io/antibody | sudo sh -s - -b /usr/local/bin

# Clone dotfiles
cd ~
git clone git@github.com:dwhdai/.dotfiles.git

# Stow configs
cd ~/.dotfiles
stow nvim
stow p10k
stow tmux
stow zsh

# Install pyenv and dependencies for pyenv
sudo apt-get update; sudo apt-get install -y make build-essential libssl-dev zlib1g-dev \
	libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
	libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev

curl https://pyenv.run | bash
pyenv install 3.8.13
pyenv global 3.8.13
python -m pip install -U pip setuptools wheel virtualenv

# Install poetry and its dependencies
sudo apt install -y python3.8-venv
curl -sSL https://install.python-poetry.org | python3.8 -
export PATH="/home/ubuntu/.local/bin:$PATH"

# Change git default editor
git config --global core.editor "vi"
