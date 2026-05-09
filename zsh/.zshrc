# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Install plugins
source /opt/homebrew/opt/antidote/share/antidote/antidote.zsh
antidote load $HOME/.zsh_plugins.txt

# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# Load api keys
#export ANTHROPIC_API_KEY=$(pass show anthropic_key)

# Source aliases
for a in $HOME/.zsh/aliases/*
do
  source $a
done

# Line navigation shortcuts
bindkey "^H" backward-word
bindkey "^L" forward-word
bindkey '^[[3;3~' kill-word 


# Path additions
export PATH="$HOME/.poetry/bin:$PATH"
export PATH="$HOME/.dotfiles/scripts:$PATH"
export PATH="/Users/david/.local/bin:$PATH"
export PATH="$HOME/.local/share/bob/nvim-bin:$PATH"
export PATH="/Applications/Ghostty.app/Contents/MacOS:$PATH"
precmd () {print -Pn "\e]0;%~\a"}

# pyenv paths
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# direnv
eval "$(direnv hook zsh)"

autoload -Uz compinit && compinit

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /opt/homebrew/bin/terraform terraform

# Created by `pipx` on 2024-03-16 23:21:16
export PATH="$PATH:/Users/daviddai/.local/bin"
#. /Users/david/.evenup_zshrc

# bun
export BUN_INSTALL="$HOME/Library/Application Support/reflex/bun"
export PATH="$BUN_INSTALL/bin:$PATH"


# zsh-history-substring-search config
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down


# zoxide
eval "$(zoxide init zsh)"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/opt/homebrew/share/google-cloud-sdk/path.zsh.inc' ]; then . '/opt/homebrew/share/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/opt/homebrew/share/google-cloud-sdk/completion.zsh.inc' ]; then . '/opt/homebrew/share/google-cloud-sdk/completion.zsh.inc'; fi

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/daviddai/.lmstudio/bin"
# End of LM Studio CLI section


# Secrets
export TEMPORAL_API_KEY=$(security find-generic-password -a "daviddai" -s "TEMPORAL_API_KEY" -w 2>/dev/null)
export GITHUB_TOKEN=$(gh auth token 2>/dev/null)
