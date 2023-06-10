# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

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

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
