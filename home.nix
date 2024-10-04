{pkgs, ...}: {
  home.username = "jericho";
  home.homeDirectory = "/home/jericho";
  home.stateVersion = "23.11";

  home.file.".ansible.cfg".text = ''
  [defaults]
  strategy_plugins = ${pkgs.python311Packages.mitogen}/lib/python3.11/site-packages/ansible_mitogen/plugins/strategy/
  strategy = mitogen_linear
  '';

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };
  };

  programs.home-manager.enable = true;

  programs.rbw = {
    enable = true;
    settings = {
      base_url = "https://pass.jkeyne.dev";
      email = "jerichokeyne@gmail.com";
      # pinentry = pkgs.mate.mate-polkit;
      pinentry = pkgs.pinentry-gnome3;
    };
  };

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    enableNushellIntegration = true;
    nix-direnv.enable = true;
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
    historyControl = ["erasedups" "ignorespace"];
    initExtra = ''
    export PATH="$HOME/go/bin:$HOME/.cargo/bin:$HOME/.local/bin:$PATH"
    export XDG_DATA_DIRS="$XDG_DATA_DIRS:/usr/share:/var/lib/flatpak/exports/share:$HOME/.local/share/flatpak/exports/share"
    export EDITOR="hx"

    # For local ROSA testing
    export RHCS_CLUSTER_NAME_PREFIX=jkeyne # terraform
    export NAME_PREFIX=jkeyne # ROSA CLI

    eval $(ssh-agent)
    if command -v rosa &>/dev/null; then
      source <(rosa completion bash)
    fi
    if command -v ocm &>/dev/null; then
      source <(ocm completion bash)
    fi
    '';
  };

  programs.atuin = {
    enable = true;
    enableBashIntegration = true;
    flags = ["--disable-up-arrow"];
    settings = {
      filter_mode_shell_up_key_binding = "session";
      enter_accept = false;
    };
  };

  programs.git = {
    enable = true;
    delta.enable = true;

    userName = "Jericho Keyne";
    userEmail = "jkeyne@redhat.com";

    ignores = [
      "Pipfile"
      "justfile"
      "*.lock"
      "!flake.lock"
      "*.swp"
      "*~"
      ".env"
      ".envrc"
      "shell.nix"
    ];

    extraConfig = {
      http.sslVerify = false;
      push.autoSetupRemote = true;
    };
  };

  programs.zoxide.enable = true;
  programs.bat.enable = true;
  programs.lsd = {
    enable = true;
    enableAliases = true;
  };
  programs.starship = {
    enable = true;
    enableBashIntegration = true;
  };
}
