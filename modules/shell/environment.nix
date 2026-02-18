{ ... }: {
  xdg.enable = true;

  home.sessionVariables = {
    EDITOR = "vim";
    BROWSER = "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome";
    READER = "zathura";
    FZF_DEFAULT_COMMAND = ''rg --files --no-ignore --hidden --follow --glob "!.git/*" --glob "!.jj/*"'';
    NO_AT_BRIDGE = "1";

    # Java
    JAVA_HOME = "$(/usr/libexec/java_home)";

    # Android
    ANDROID_HOME = "$HOME/Library/Android/sdk";
    ANDROID_SDK_HOME = "$HOME/Library/Android/sdk";

    # XDG overrides for programs that don't respect it
    ADB_VENDOR_KEY = "$XDG_CONFIG_HOME/android";
    GRADLE_USER_HOME = "$XDG_DATA_HOME/gradle";
    NODE_REPL_HISTORY = "$XDG_DATA_HOME/node_repl_history";
    SQLITE_HISTORY = "$XDG_DATA_HOME/sqlite_history";
    STACK_ROOT = "$XDG_DATA_HOME/stack";

    # Dev tools
    OPENCODE_EXPERIMENTAL_LSP_TY = "true";
    OPENCODE_EXPERIMENTAL_OXFMT = "true";
    ENABLE_INCREMENTAL_TUI = "true";
  };

  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/.cargo/bin"
    "$HOME/.radicle/bin"
    "$HOME/Library/Android/sdk/build-tools/35.0.0"
  ];
}
