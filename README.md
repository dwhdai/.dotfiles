# .dotfiles
dotfiles for stuff



## cloning
In order to easily leverage GNU stow, this repository should be cloned within the `$HOME` directory.

## setting up new (mac) machine

1. install homebrew: `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`
2. clone this repository in `$HOME`: `cd $HOME && git clone git@github.com:dwhdai/.dotfiles.git"
3. install things with brew: `brew bundle`

## using stow
GNU stow is used to create symlinks between this repository to the `$HOME` directory. To do this, run `stow <package>`. 

For example, to stow the `nvim` configs: `stow nvim`

## bash scripts
Various bash scripts are in the `scripts/` folder. This directory is appended to the PATH so that these scripts can be executed anywhere. Execution permission should be provided to these scripts to make them executable:

For example: `chmod +x scripts/ide`
