# .dotfiles
dotfiles for stuff

# using stow
GNU stow is used to create symlinks between this repository to the `$HOME` directory. To do this, run `stow --target=$HOME <package>`. 

For example, to stow the `.config` folder: `stow --target=$HOME .config`
