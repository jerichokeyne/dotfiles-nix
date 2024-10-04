{pkgs, ...}: {
  # Add language servers
  home.packages = with pkgs; [
    nil
    terraform-ls
    nodePackages_latest.bash-language-server
    clang-tools
    lldb
    omnisharp-roslyn
    clojure-lsp
    cmake-language-server
    gopls
    # nodePackages_latest.vscode-langservers-extracted
    nodePackages_latest.typescript-language-server
    marksman
    python311Packages.python-lsp-server
    rust-analyzer
    taplo
    vhdl-ls
    nodePackages_latest.yaml-language-server
    zls
    openscad-lsp
  ];
  programs.helix = {
    enable = true;
    defaultEditor = true;

    settings = {
      theme = "tokyonight_storm";

      editor = {
        bufferline = "always";
        cursorline = true;
        cursorcolumn = true;
        auto-completion = true;
        auto-format = true;
        auto-save = true;
        color-modes = true;
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
        statusline = {
          left = [
            "mode"
            "spinner"
            "spacer"
            "diagnostics"
            "version-control"
          ];
          center = [
            "file-name"
          ];
          right = [
            "diagnostics"
            "selections"
            "position"
            "file-encoding"
            "file-line-ending"
            "file-type"
          ];
          separator = "│";
          mode = {
            normal = "NORMAL";
            insert = "INSERT";
            select = "SELECT";
          };
        };
        lsp = {
          display-messages = true;
          auto-signature-help = true;
          display-signature-help-docs = true;
          display-inlay-hints = true;
        };
        whitespace = {
          render = {
            space = "all";
            tab = "all";
            newline = "none";
          };
          characters = {
            space = "·";
            nbsp = "⍽";
            tab = "→";
            newline = "⏎";
            tabpad = "·"; # Tabs will look like "→···" (depending on tab width)
          };
        };
        indent-guides = {
          render = true;
          character = "╎"; # Some characters that work well: "▏", "┆", "┊", "⸽"
          skip-levels = 0;
        };
      };
    };
  };
}
