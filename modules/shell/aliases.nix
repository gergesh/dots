{ ... }: {
  programs.zsh = {
    shellAliases = {
      # ls improvements
      ls = "ls --color=auto";
      ll = "ls -lA";

      # git
      g = "git";
      ga = "git add";
      gaa = "git add --all";
      gc = "git commit --verbose";
      gcm = "git commit --message";
      gcam = "git commit --all --message";
      gcf = "git commit --amend --no-edit";
      gcl = "git clone";
      gb = "git branch";
      gba = "git branch --all";
      gd = "git diff";
      gds = "git diff --staged";
      gch = "git checkout";
      gchm = "git checkout master";
      gchb = "git checkout -B";
      gl = "git log --decorate";
      glg = "git log --decorate --graph";
      glo = "git log --decorate --graph --oneline";
      gld = "git log --decorate --graph --patch";
      gp = "git push";
      gpa = "git push --all";
      gpo = "git push origin";
      gpom = "git push origin master";
      gplm = "git pull";
      gplr = "git pull --rebase";
      gri = "git rebase -i";

      # Safety
      del = "trash-put";

      # fasd utils
      v = "f -e vim";
      m = "f -e mpv";
      o = "a -e open";

      # fzf shortcuts
      fv = ''vim "$(fzf)"'';
      fo = ''open "$(fzf)"'';
      fm = ''mpv "$(fzf)"'';

      # Cleaning up $HOME
      mitmproxy = ''mitmproxy --set confdir=''${XDG_CONFIG_HOME:-$HOME/.config}/mitmproxy'';
      mitmdump = ''mitmdump --set confdir=''${XDG_CONFIG_HOME:-$HOME/.config}/mitmproxy'';
      mitmweb = ''mitmweb --set confdir=''${XDG_CONFIG_HOME:-$HOME/.config}/mitmproxy'';

      # Misc
      chrome = "/Applications/Google\\ Chrome.app/Contents/MacOS/Google\\ Chrome";
      epoch = "date +%s";
      vi = "vim";
      cmusync = "tail -f -n 1 ~/.config/cmus/cmusync 2> /dev/null";
      py = "python";
      oc = "opencode";
    };

    initExtra = ''
      # Functions (can't be shellAliases)
      gs() {
          if [ $# -eq 0 ]; then
              git status
          else
              git show "$@"
          fi
      }
      _gs() {
          (( CURRENT++ ))
          words[1]=(git show)
          _normal
      }
      compdef _gs gs

      mkd() { mkdir -p "$1" && cd "$1" }
      bak() { cp -ri -- "$1" "$1.bak" }

      # macOS-compatible waitpid: poll until a PID exits
      waitpid() {
          while kill -0 "$1" 2>/dev/null; do
              sleep 0.5
          done
      }
    '';
  };
}
