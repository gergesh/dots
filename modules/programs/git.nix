{ user, ... }: {
  programs.git = {
    enable = true;
    userName = user.fullName;
    userEmail = user.email;

    extraConfig = {
      core.autocrlf = "input";
      init.defaultBranch = "master";
      push.autoSetupRemote = true;

      credential."https://github.com" = {
        helper = "!/usr/bin/env gh auth git-credential";
      };
      credential."https://gist.github.com" = {
        helper = "!/usr/bin/env gh auth git-credential";
      };

      # Fix trailing whitespace across dirty tree + index combinations
      alias.fixws-global-tree-and-index = ''!"
        if (! git diff-files --quiet .) && \
           (! git diff-index --quiet --cached HEAD) ; then \
          git commit -m FIXWS_SAVE_INDEX && \
          git add -u :/ && \
          git commit -m FIXWS_SAVE_TREE && \
          git rebase --whitespace=fix HEAD~2 && \
          git reset HEAD~ && \
          git reset --soft HEAD~ ; \
        elif (! git diff-files --quiet .) ; then \
          git add -u :/ && \
          git commit -m FIXWS_SAVE_TREE && \
          git rebase --whitespace=fix HEAD~ && \
          git reset HEAD~ ; \
        elif (! git diff-index --quiet --cached HEAD) ; then \
          git commit -m FIXWS_SAVE_INDEX && \
          git rebase --whitespace=fix HEAD~ && \
          git reset --soft HEAD~ ; \
        fi"'';
    };
  };

  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        name = user.fullName;
        email = user.email;
      };

      ui.diff-editor = ":builtin";

      revset-aliases = {
        "closest_bookmark(to)" = "heads(::to & bookmarks())";
        "closest_pushable(to)" = ''heads(::to & ~description(exact:"") & (~empty() | merges()))'';
      };

      aliases = {
        e = [ "edit" ];
        d = [ "diff" ];
        l = [ "log" ];
        add = [ "file" "track" ];
        dup = [ "duplicate" ];
        cm = [ "commit" "-m" ];
        desc = [ "describe" ];
        push = [
          "util" "exec" "--" "uvx" "jj-pre-push"
          "--checker" "prek" "push"
        ];
        p = [ "push" ];
        release = [
          "util" "exec" "--" "sh" "-c"
          ''
            set -e
            version="$1"
            if [ -z "$version" ]; then
              echo "Usage: jj release <vX.Y.Z>" >&2
              exit 1
            fi
            jj commit -m "Release $version"
            jj tag set "$version" -r @-
          ''
          ""
        ];
        tug = [
          "util" "exec" "--" "sh" "-c"
          ''
            if [ "x$1" = "x" ]; then
              jj bookmark move --from "closest_bookmark(@)" --to "closest_pushable(@)"
            else
              jj bookmark move --to "closest_pushable(@)" "$@"
            fi
          ''
          ""
        ];
      };

      snapshot.auto-track = "none()";

      git.private-commits = "description(glob:'private:*')";

      diff.color-words.max-inline-alternation = 1;

      template-aliases = {
        "builtin_log_compact(commit)" = ''
          if(commit.root(),
            format_root_commit(commit),
            label(
              separate(" ",
                if(commit.current_working_copy(), "working_copy"),
                if(commit.immutable(), "immutable", "mutable"),
                if(commit.conflict(), "conflicted"),
              ),
              concat(
                "Change ",
                format_short_commit_header(commit) ++ "\n",
                separate(" ",
                  if(commit.empty(), empty_commit_marker),
                  if(commit.description(),
                    commit.description().first_line(),
                    label(if(commit.empty(), "empty"), description_placeholder),
                  ),
                ) ++ "\n",
              ),
            )
          )
        '';
      };
    };
  };
}
