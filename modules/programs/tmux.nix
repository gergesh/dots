{ pkgs, ... }: {
  programs.tmux = {
    enable = true;
    prefix = "C-a";
    baseIndex = 1;
    escapeTime = 0;
    keyMode = "vi";
    mouse = true;
    historyLimit = 100000;
    terminal = "xterm-256color";

    plugins = with pkgs.tmuxPlugins; [
      nord
    ];

    extraConfig = ''
      # Press C-a twice to switch to last window
      bind-key C-a last-window

      # Pane base index
      setw -g pane-base-index 1

      # Switch panes, aware of vim splits (vim-tmux-navigator)
      is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
          | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"
      bind-key -n C-Left  if-shell "$is_vim" 'send-keys C-Left'  'select-pane -L'
      bind-key -n C-Down  if-shell "$is_vim" 'send-keys C-Down'  'select-pane -D'
      bind-key -n C-Up    if-shell "$is_vim" 'send-keys C-Up'    'select-pane -U'
      bind-key -n C-Right if-shell "$is_vim" 'send-keys C-Right' 'select-pane -R'
      bind-key -n C-h     if-shell "$is_vim" 'send-keys C-h'     'select-pane -L'
      bind-key -n C-j     if-shell "$is_vim" 'send-keys C-j'     'select-pane -D'
      bind-key -n C-k     if-shell "$is_vim" 'send-keys C-k'     'select-pane -U'
      bind-key -n C-l     if-shell "$is_vim" 'send-keys C-l'     'select-pane -R'
      bind-key -T copy-mode-vi -n C-Left  select-pane -L
      bind-key -T copy-mode-vi -n C-Down  select-pane -D
      bind-key -T copy-mode-vi -n C-Up    select-pane -U
      bind-key -T copy-mode-vi -n C-Right select-pane -R
      bind-key -T copy-mode-vi -n C-h     select-pane -L
      bind-key -T copy-mode-vi -n C-j     select-pane -D
      bind-key -T copy-mode-vi -n C-k     select-pane -U
      bind-key -T copy-mode-vi -n C-l     select-pane -R

      # Switch windows
      bind-key -n M-Left previous-window
      bind-key -n M-Right next-window
      bind-key -n M-h previous-window
      bind-key -n M-l next-window

      # Swap panes
      bind-key -n S-Up swap-pane -U
      bind-key -n S-Down swap-pane -D

      # Swap windows
      bind-key -n S-Left swap-window -d -t -1
      bind-key -n S-Right swap-window -d -t +1

      # Resize panes
      bind-key -n C-S-Left resize-pane -L
      bind-key -n C-S-Right resize-pane -R
      bind-key -n C-S-Up resize-pane -U
      bind-key -n C-S-Down resize-pane -D
      bind-key -n C-S-h resize-pane -L
      bind-key -n C-S-l resize-pane -R
      bind-key -n C-S-k resize-pane -U
      bind-key -n C-S-j resize-pane -D

      # Copy-paste (macOS: pbcopy instead of xclip)
      bind-key p paste-buffer
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi C-v send-keys -X begin-selection\; send-keys -X rectangle-toggle
      bind-key -T copy-mode-vi y send-keys -X copy-pipe-and-cancel 'pbcopy'
      bind-key -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel 'pbcopy'
      bind-key -T copy-mode-vi r send-keys -X rectangle-toggle

      # Cycle between prompts
      bind -T copy-mode-vi [ send-keys -X search-backward λ
      bind -T copy-mode-vi ] send-keys -X search-forward  λ

      # Temporary cmus controller
      bind-key n run-shell "tmux-run-fg cmus"
    '';
  };
}
