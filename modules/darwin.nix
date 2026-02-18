{ pkgs, ... }: {
  # System-level packages from nixpkgs
  environment.systemPackages = with pkgs; [
    # Core utilities
    coreutils
    curl
    fd
    fzf
    gawk
    gnu-sed
    jq
    ripgrep
    ripgrep-all
    watch
    wget

    # Editors
    helix
    neovim

    # VCS
    git
    git-crypt
    git-delta
    git-filter-repo
    gh
    jujutsu

    # Languages / runtimes
    deno
    go
    nim
    zig
    uv

    # Shells / terminal
    atuin
    btop
    htop
    ncdu
    tmux

    # Networking / security
    aircrack-ng
    gnupg
    mosh
    nmap
    rage
    syncthing
    tailscale
    tor
    wireshark

    # File tools
    atool
    bzip2
    cabextract
    dos2unix
    exiftool
    hexyl
    icoutils
    innoextract
    mediainfo
    potrace
    qpdf
    unar
    unrar

    # Dev tools
    binutils
    binwalk
    bvi
    cloc
    cmake
    difftastic
    direnv
    fswatch
    gron
    imagemagick
    just
    meson
    pandoc
    radare2
    rename
    shellcheck
    vbindiff

    # Data / databases
    duckdb
    pgcli

    # Python
    ipython

    # Misc
    croc
    espeak
    gifski
    httrack
    irssi
    the_silver_searcher
    typst
    yt-dlp
  ];

  # Homebrew -- managed declaratively by nix-darwin
  homebrew = {
    enable = true;

    onActivation = {
      cleanup = "uninstall";
      autoUpdate = true;
      upgrade = true;
    };

    taps = [
      "aliev/tap"
      "facebook/fb"
      "gromgit/fuse"
      "max-sixty/worktrunk"
      "mongodb/brew"
      "morantron/tmux-fingers"
      "oven-sh/bun"
      "raybytes/chatmock"
      "shopify/shopify"
      "speakeasy-api/tap"
      "supabase/tap"
      "tursodatabase/tap"
    ];

    brews = [
      # Tap-specific
      "aliev/tap/baker"
      "facebook/fb/idb-companion"
      "gromgit/fuse/s3fs-mac"
      "max-sixty/worktrunk/wt"
      "mongodb/brew/mongodb-community"
      "morantron/tmux-fingers/tmux-fingers"
      "oven-sh/bun/bun"
      "raybytes/chatmock/chatmock"
      "shopify/shopify/shopify-cli"
      "speakeasy-api/tap/speakeasy"
      "supabase/tap/supabase"
      "tursodatabase/tap/turso"

      # Mobile development
      "bundletool"
      "cocoapods"
      "fastlane"
      "gnirehtet"
      "ipatool"
      "ios-deploy"
      "libimobiledevice"
      "scrcpy"

      # Language runtimes / version managers
      "crystal"
      "fnm"
      "kotlin"
      "kotlin-language-server"
      "mise"
      "mono"
      "openjdk@11"
      "openjdk@17"
      "php"
      "python-tk@3.13"
      "python@3.10"
      "ruby"

      # Databases
      "postgresql@14"
      "postgresql@17"
      "redis"

      # JS/TS / Python package managers
      "pipenv"
      "pipx"
      "pnpm"
      "yarn"

      # Security / reverse engineering
      "apktool"
      "autopsy"
      "gobuster"
      "jadx"
      "reaver"
      "semgrep"
      "trufflehog"

      # Dev tools
      "aider"
      "binaryen"
      "bk"
      "closure-compiler"
      "copier"
      "foundry"
      "hk"
      "jjui"
      "js-beautify"
      "jqp"
      "lazyjj"
      "lefthook"
      "mcp-inspector"
      "opencode"
      "overmind"
      "oxfmt"
      "oxlint"
      "prek"
      "sleepwatcher"
      "spicetify-cli"
      "steamguard-cli"
      "tmuxai"
      "wasm-tools"
      "zsh-completions"

      # Cloud / networking
      "awscli"
      "cloudflared"
      "hcloud"
      "helm"
      "kubernetes-cli"
      "livekit"
      "megacmd"
      "megatools"

      # Servers
      "caddy"
      "pocketbase"
      "snitch"
      "static-web-server"

      # macOS-specific utilities
      "blueutil"
      "cliclick"
      "pngpaste"
      "terminal-notifier"

      # Misc
      "demumble"
      "epr"
      "git-remote-codecommit"
      "git-remote-gcrypt"
      "jid"
      "lsusb"
      "mame"
      "magic-wormhole.rs"
      "md5sha1sum"
      "mingw-w64"
      "mole"
      "mpack"
      "nss"
      "opencv"
      "osslsigncode"
      "pyinstaller"
      "qt"
      "scikit-image"
      "sha2"
      "sponge"
      "torchvision"
      "tesseract-lang"
    ];

    casks = [
      "alt-tab"
      "amitv87-pip"
      "android-platform-tools"
      "android-studio"
      "anydesk"
      "balenaetcher"
      "bambu-studio"
      "bitwarden"
      "burp-suite"
      "caido"
      "calibre"
      "claude"
      "claudine"
      "clion"
      "codeql"
      "codex"
      "comfyui"
      "commander-one"
      "cursor"
      "db-browser-for-sqlite"
      "discord"
      "docker"
      "docker-desktop"
      "expo-orbit"
      "figma"
      "font-inter"
      "font-rubik"
      "freemind"
      "gcloud-cli"
      "ghidra"
      "ghostty"
      "gstreamer-runtime"
      "halloy"
      "handy"
      "hex-fiend"
      "http-toolkit"
      "jslegendre-themeengine"
      "lm-studio"
      "macfuse"
      "mitmproxy"
      "mongodb-compass"
      "ngrok"
      "notion"
      "notunes"
      "numi"
      "obs"
      "postman"
      "protonvpn"
      "proxifier"
      "qflipper"
      "quarto"
      "raycast"
      "rectangle"
      "rustdesk"
      "sage"
      "send-to-kindle"
      "spotify"
      "stolendata-mpv"
      "superwhisper"
      "syncthing"
      "syncthing-app"
      "telegram"
      "the-unarchiver"
      "ticktick"
      "tigervnc"
      "tigervnc-viewer"
      "tradingview"
      "ultimate-vocal-remover"
      "veracrypt"
      "wine-stable"
      "wireshark"
      "wireshark-app"
      "zoom"
    ];
  };

  # Touch ID for sudo
  security.pam.services.sudo_local.touchIdAuth = true;

  # macOS system preferences
  system.defaults = {
    dock = {
      autohide = true;
      mru-spaces = false;
      show-recents = false;
      tilesize = 64;
    };
    finder = {
      AppleShowAllExtensions = true;
      FXEnableExtensionChangeWarning = false;
    };
    NSGlobalDomain = {
      AppleShowAllExtensions = true;
      InitialKeyRepeat = 15;
      KeyRepeat = 2;
    };
  };
}
