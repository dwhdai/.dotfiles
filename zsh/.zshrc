# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source <(antibody init)
antibody bundle < ~/.zsh_plugins.txt


# Source aliases
for a in $HOME/.zsh/aliases/*
do
  source $a
done

# Plugin configs
source .zsh-autosuggestions

# Keybindings
#bindkey '^ ' autosuggest-accept


# Line navigation shortcuts
bindkey "^B" backward-word
bindkey "^F" forward-word

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
