# Install plugins
antibody bundle < ~/.zsh_plugins.txt > ~/.zsh_plugins.sh
source ~/.zsh_plugins.sh

# Source aliases
for a in $HOME/.zsh/aliases/*
do
  source $a
done

# Line navigation shortcuts
bindkey "^B" backward-word
bindkey "^F" forward-word

bindkey -v

# Path additions
export PATH="$HOME/.poetry/bin:$PATH"
export PATH="$HOME/.dotfiles/scripts:$PATH"
precmd () {print -Pn "\e]0;%~\a"}
# pyenv paths
eval "$(pyenv init --path)"

autoload -Uz compinit && compinit
