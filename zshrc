# Source environment variables
[ -f "$HOME/.config/exportrc" ] && source "$HOME/.config/exportrc"

# Colors and prompt
autoload -U colors && colors
[ -n "$SSH_CLIENT" ] && PS1_HOSTNAME="@$(hostname)"
PS1="%F{blue}λ %1~$PS1_HOSTNAME %f"

# History
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.cache/zsh_history

# Autocompletion
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit -d "${XDG_CACHE_HOME:-$HOME/.cache}/zcompdump"
_comp_options+=(globdots)

# Quote pasted URLs automatically
autoload -Uz url-quote-magic
zle -N self-insert url-quote-magic
autoload -Uz bracketed-paste-magic
zle -N bracketed-paste bracketed-paste-magic

# Make lowercase letters match both lowercase and uppercase letters, but only if no exact matches are found.
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'

# vi mode
bindkey -v
export KEYTIMEOUT=1

# Fix common keys
bindkey "^[[1~" beginning-of-line
bindkey "^[[3~" delete-char
bindkey "^[[4~" end-of-line

# Search history using Up and Down keys
autoload -U history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^[[A" history-beginning-search-backward-end
bindkey "^[[B" history-beginning-search-forward-end

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char

# Change cursor shape for different vi modes.
zle-keymap-select() {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select

zle-line-init() {
    echo -ne "\e[5 q"
}
zle -N zle-line-init

# Load the zmv function
autoload -Uz zmv

# p shortcut
accept-line() {
    if [[ $BUFFER = p\ * ]]; then
        python3 ~/.local/lib/p_wrapper.py "${BUFFER#p }"
    fi
    zle .accept-line
}
zle -N accept-line
alias p='#'

# Edit line in vim with ctrl-e:
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line

# Clear the screen using C-x
bindkey '^x' clear-screen

# Swap last two characters using C-t
bindkey '^t' gosmacs-transpose-chars

# Keep trailing slashes on commands
setopt no_auto_remove_slash

# Allow comments in repl
setopt interactive_comments

# Load other configuration files
[ -f "$HOME/.config/aliasrc" ] && source "$HOME/.config/aliasrc"
[ -f "$HOME/.config/machinerc" ] && source "$HOME/.config/machinerc"

# Load fasd shortcuts
command -v fasd > /dev/null && eval "$(fasd --init auto)"
