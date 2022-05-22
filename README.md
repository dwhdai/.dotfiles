# .dotfiles
dotfiles for stuff

# cloning
In order to easily leverage GNU stow, this repository should be cloned within the `$HOME` directory.

# using stow
GNU stow is used to create symlinks between this repository to the `$HOME` directory. To do this, run `stow <package>`. 

For example, to stow the `nvim` configs: `stow nvim`

# bash scripts
Various bash scripts are in the `scripts/` folder. This directory is appended to the PATH so that these scripts can be executed anywhere. Execution permission should be provided to these scripts to make them executable:

For example: `chmod +x scripts/ide`
