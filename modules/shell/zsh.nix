{ ... }: {
  programs.zsh = {
    enable = true;
    autosuggestion.enable = false;
    syntaxHighlighting.enable = false;

    history = {
      size = 1000000;
      save = 1000000;
      path = "$HOME/.cache/zsh_history";
      share = true;
      append = true;
      ignoreSpace = true;
    };

    defaultKeymap = "viins";

    completionInit = ''
      autoload -U compinit
      zstyle ':completion:*' menu select
      zmodload zsh/complist
      compinit -d "''${XDG_CACHE_HOME:-$HOME/.cache}/zcompdump"
      _comp_options+=(globdots)

      # Case-insensitive completion (only when no exact match)
      zstyle ':completion:*' matcher-list "" "m:{a-zA-Z}={A-Za-z}"
    '';

    initExtra = ''
      # Colors and prompt
      autoload -U colors && colors
      [ -n "$SSH_CLIENT" ] && PS1_HOSTNAME="@$(hostname)"
      PS1="%F{blue}λ %1~$PS1_HOSTNAME %f"

      # Vi mode key timeout
      export KEYTIMEOUT=1

      # Fix common keys
      bindkey "^?" backward-delete-char
      bindkey "^[[1~" beginning-of-line
      bindkey "^[[3~" delete-char
      bindkey "^[[4~" end-of-line

      # Search history using Up and Down keys
      autoload -U history-search-end
      zle -N history-beginning-search-backward-end history-search-end
      zle -N history-beginning-search-forward-end history-search-end
      bindkey "^[[A" history-beginning-search-backward-end
      bindkey "^[[B" history-beginning-search-forward-end

      # Use vim keys in tab complete menu
      bindkey -M menuselect 'h' vi-backward-char
      bindkey -M menuselect 'j' vi-down-line-or-history
      bindkey -M menuselect 'k' vi-up-line-or-history
      bindkey -M menuselect 'l' vi-forward-char

      # Change cursor shape for different vi modes
      zle-keymap-select() {
        if [[ ''${KEYMAP} == vicmd ]] ||
           [[ $1 = 'block' ]]; then
          echo -ne '\e[1 q'
        elif [[ ''${KEYMAP} == main ]] ||
             [[ ''${KEYMAP} == viins ]] ||
             [[ ''${KEYMAP} = "" ]] ||
             [[ $1 = 'beam' ]]; then
          echo -ne '\e[5 q'
        fi
      }
      zle -N zle-keymap-select

      zle-line-init() {
          echo -ne "\e[5 q"
      }
      zle -N zle-line-init

      # Quote pasted URLs automatically
      autoload -Uz url-quote-magic
      zle -N self-insert url-quote-magic
      autoload -Uz bracketed-paste-magic
      zle -N bracketed-paste bracketed-paste-magic

      # Load the zmv function
      autoload -Uz zmv
      alias mmv='noglob zmv -W'

      # p shortcut
      accept-line() {
          if [[ $BUFFER = p\ * ]]; then
              python3 ~/.local/lib/p_wrapper.py "''${BUFFER#p }"
          fi
          zle .accept-line
      }
      zle -N accept-line
      alias p='#'

      # Edit line in vim with ctrl-e
      autoload edit-command-line; zle -N edit-command-line
      bindkey '^e' edit-command-line

      # Clear the screen using C-x
      bindkey '^x' clear-screen

      # Swap last two characters using C-t
      bindkey '^t' gosmacs-transpose-chars

      # Allow C-q and C-s keys
      stty -ixon

      # Comment/uncomment using C-s
      bindkey '^s' vi-pound-insert

      # Keep trailing slashes on commands
      setopt no_auto_remove_slash

      # Allow comments in repl
      setopt interactive_comments

      # Named directories (hash shortcuts)
      hash -d win="/Volumes/[C] Windows 11"
      hash -d adl=~win/Users/yoav/AppData/Local
      hash -d wy="/Volumes/[C] Windows 11/Users/yoav"
      hash -d wyv=~wy/Videos
      hash -d windocs=~wy/Videos
      hash -d t=~/temp

      # Update ~ld to point to the newest file in ~/Downloads at every prompt
      precmd() {
        local -a latest=(~/Downloads/*(om[1]))
        if (( $#latest )); then
          hash -d ld="$latest[1]"
        else
          hash -d ld="$HOME/Downloads"
        fi
      }

      # Source machine-specific config if present
      [ -f "$HOME/.config/machinerc" ] && source "$HOME/.config/machinerc"

      # Load fasd shortcuts
      command -v fasd > /dev/null && eval "$(fasd --init auto)"

      # uv completions
      eval "$(uv generate-shell-completion zsh)"
      _uv_run_mod() {
          if [[ "$words[2]" == "run" && "$words[CURRENT]" != -* ]]; then
              if [[ ''${words[3,$((CURRENT-1))]} =~ ".*\.py" ]]; then
                  _arguments '*:filename:_files'
              else
                  _arguments '*:filename:_files -g "*.py"'
              fi
          else
              _uv "$@"
          fi
      }
      compdef _uv_run_mod uv

      # fnm (Node version manager)
      eval "$(fnm env)"

      # Atuin shell history
      eval "$(atuin init zsh --disable-up-arrow)"

      # direnv
      eval "$(direnv hook zsh)"

      # Custom direnv wrapper with a 'use' subcommand
      direnv() {
        if [[ "''${1-}" == "use" ]]; then
          local dir="$PWD"
          while [[ "$dir" != "/" && ! -f "$dir/.envrc" ]]; do
            dir="$(dirname "$dir")"
          done
          if [[ ! -f "$dir/.envrc" ]]; then
            echo "direnv: couldn't find a .envrc in this directory or any parent." >&2
            return 1
          fi
          shift
          local mode="''${1-}"
          if [[ -z "$mode" ]]; then
            cat "$dir/.envrc.current"
            return 0
          fi
          echo "$mode" > "$dir/.envrc.current"
        else
          command direnv "$@"
        fi
      }

      # Completion for: direnv use <mode>
      _direnv_use_complete() {
        local -a modes
        local dir=$PWD
        if (( CURRENT == 3 )) && [[ ''${words[2]} == set ]]; then
          while [[ "$dir" != "/" && ! -f "$dir/.envrc" ]]; do
            dir=''${dir:h}
          done
          [[ -f "$dir/.envrc" ]] || dir=$PWD
          local f base m
          for f in "$dir"/.env.*(N); do
            base=''${f:t}
            m=''${base#.env.}
            [[ -n "$m" && "$m" != "$base" ]] && modes+="$m"
          done
          typeset -U modes
          if (( ''${#modes} )); then
            _describe -t modes 'environment' modes
            return
          fi
        fi
        _files
      }
      compdef _direnv_use_complete direnv

      # wt (worktrunk)
      if command -v wt >/dev/null 2>&1; then eval "$(command wt config shell init zsh)"; fi

      alias cclear="clear && printf '\e[3J'"
      alias cc='claude --dangerously-skip-permissions'
      alias td="cd $(mktemp -d)"
    '';
  };
}
