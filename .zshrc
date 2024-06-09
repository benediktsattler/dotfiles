### ---- ZINIT HOME -----------------------------------
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

### ---- Load Zinit -----------------------------------
if [ ! -d "${ZINIT_HOME}" ]; then
  mkdir -p "$(dirname $ZINIT_HOME)"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
### ---- Source Zinit -----------------------------------
source "${ZINIT_HOME}/zinit.zsh"

### ---- Add zsh plugins -----------------------------------
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions

### ---- autocompletions -----------------------------------
# fpath=(~/.zsh/site-functions $fpath)
autoload -Uz compinit && compinit

### ---- Completion options and styling -----------------------------------
zstyle ':completion:*' menu select # selectable menu
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
#zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]-_}={[:upper:][:lower:]_-}' 'r:|=*' 'l:|=* r:|=*' # case insensitive completion
zstyle ':completion:*' list-colors '' # colorize completion lists

# Add zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions

# Load completions
autoload -U compinit && compinit

### ---- History options -----------------------------------
HISTSIZE=10000
SAVEHIST=$HISTSIZE
HISTFILE=~/.config/zsh/.zsh_history
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

export PATH="/usr/local/opt/node@14/bin:$PATH"
export LDFLAGS="-L/usr/local/opt/node@14/lib"
export CPPFLAGS="-I/usr/local/opt/node@14/include"
export NVM_DIR=~/.nvm
source $(brew --prefix nvm)/nvm.sh

export PATH="/usr/local/sbin:$PATH"

#export NVM_DIR="/Users/benedikt/Library/Application Support/Herd/config/nvm"
#[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

[[ -f "/Applications/Herd.app/Contents/Resources/config/shell/zshrc.zsh" ]] && builtin source "/Applications/Herd.app/Contents/Resources/config/shell/zshrc.zsh"

# Herd injected PHP binary.
export PATH="/Users/benedikt/Library/Application Support/Herd/bin/":$PATH

# Herd injected PHP 8.2 configuration.
export HERD_PHP_82_INI_SCAN_DIR="/Users/benedikt/Library/Application Support/Herd/config/php/82/"

# Herd injected PHP 8.1 configuration.
export HERD_PHP_81_INI_SCAN_DIR="/Users/benedikt/Library/Application Support/Herd/config/php/81/"

# Herd injected PHP 8.0 configuration.
export HERD_PHP_80_INI_SCAN_DIR="/Users/benedikt/Library/Application Support/Herd/config/php/80/"

### ---- aliases -----------------------------------
# Aliases
alias ls='eza'
alias l='ls -lah'
alias la='eza -lAh'
alias ll='eza -l'
alias lsa='ls -lah'

alias rm='rm -I'
alias cp='cp -i'
alias mv='mv -i'

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."

alias hidefiles='defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder'
alias showfiles='defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder'

### ---- Eval fzf -----------------------------------
eval "$(fzf --zsh)"

#if [ "$TERM_PROGRAM" != "Apple_Terminal" ]; then
#  eval "$(oh-my-posh init zsh --config ~/.config/ohmyposh/zen.toml)"
#fi

## ---- Starship -----------------------------------
eval "$(starship init zsh)"

zle-line-init() {
  emulate -L zsh

  [[ $CONTEXT == start ]] || return 0

  while true; do
    zle .recursive-edit
    local -i ret=$?
    [[ $ret == 0 && $KEYS == $'\4' ]] || break
    [[ -o ignore_eof ]] || exit 0
  done

  local saved_prompt=$PROMPT
  local saved_rprompt=$RPROMPT
  PROMPT='$(STARSHIP_CONFIG=~/.config/starship-transient.toml starship prompt --terminal-width="$COLUMNS" --keymap="${KEYMAP:-}" --status="$STARSHIP_CMD_STATUS" --pipestatus="${STARSHIP_PIPE_STATUS[*]}" --cmd-duration="${STARSHIP_DURATION:-}" --jobs="$STARSHIP_JOBS_COUNT")'
  RPROMPT=''
  zle .reset-prompt
  PROMPT=$saved_prompt
  RPROMPT=$saved_rprompt

  if ((ret)); then
    zle .send-break
  else
    zle .accept-line
  fi
  return ret
}

zle -N zle-line-init
