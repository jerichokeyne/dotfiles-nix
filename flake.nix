{
  description = "My dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
        url = "github:nix-community/home-manager";
        inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    hyprland.url = "github:hyprwm/Hyprland";
    split-monitor-workspaces = {
      url = "github:Duckonaut/split-monitor-workspaces";
      inputs.hyprland.follows = "hyprland"; # <- make sure this line is present for the plugin to work as intended
    };
  };

  outputs = {
    nixpkgs,
    home-manager,
    nixos-hardware,
    ...
  }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules =
        [ ./hardware-configuration.nix
          nixos-hardware.nixosModules.lenovo-thinkpad-p1
          ({ pkgs, ... }: {
            system.stateVersion = "23.11";

            boot.loader.systemd-boot = {
              enable = true;
              configurationLimit = 30;
              memtest86.enable = true;
              netbootxyz.enable = true;
            };
            boot.loader.efi.canTouchEfiVariables = true;

            networking.networkmanager.enable = true;
            networking.hostName = "nixos";
            networking.extraHosts =
            ''
              100.126.170.48 jericho.cc gatus.jericho.cc traefik.jericho.cc
            '';
            services.resolved = {
              enable = true;
              # dnssec = "true";
              # domains = [ "~." ];
              # fallbackDns = [ "1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one" ];
              # dnsovertls = "true";
            };
            systemd.network.wait-online.enable = false;
            boot.initrd.systemd.network.wait-online.enable = false;
            systemd.services.NetworkManager-wait-online.enable = false;

            i18n.defaultLocale = "en_US.UTF-8";
            i18n.extraLocaleSettings = {
              LC_ADDRESS = "en_US.UTF-8";
              LC_IDENTIFICATION = "en_US.UTF-8";
              LC_MEASUREMENT = "en_US.UTF-8";
              LC_MONETARY = "en_US.UTF-8";
              LC_NAME = "en_US.UTF-8";
              LC_NUMERIC = "en_US.UTF-8";
              LC_PAPER = "en_US.UTF-8";
              LC_TELEPHONE = "en_US.UTF-8";
              LC_TIME = "en_US.UTF-8";
            };
            nix.settings.experimental-features = [ "nix-command" "flakes" ];

            # # Enable the GNOME Desktop Environment.
            # services.xserver.displayManager.gdm.enable = true;
            # services.xserver.desktopManager.gnome.enable = true;
            programs.hyprland.enable = true;
            programs.hyprlock.enable = true;
            services.displayManager.sddm.enable = true;
            services.displayManager.sddm.wayland.enable = true;
            # Configure keymap in X11
            services.xserver = {
              enable = true;
              xkb = {
                variant = "";
                layout = "us";
              };
            };

            # Enable CUPS to print documents.
            services.printing.enable = true;

            # Enable sound with pipewire.
            # sound.enable = true;
            hardware.pulseaudio.enable = false;
            security.rtkit.enable = true;
            services.pipewire = {
              enable = true;
              alsa.enable = true;
              alsa.support32Bit = true;
              pulse.enable = true;
              jack.enable = true;
            };
            hardware.pulseaudio.package = pkgs.pulseaudioFull;

            hardware.bluetooth = {
              enable = true;
              powerOnBoot = true;
            };

            # Define a user account. Don't forget to set a password with ‘passwd’.
            users.users.jericho = {
              isNormalUser = true;
              description = "Jericho Keyne";
              extraGroups = [
                "networkmanager"
                "wheel"
                "docker"
                "libvirtd"
                "libvirt"
                "adbusers"
              ];
              initialPassword = "password";
              packages = with pkgs; [
                anki
                freetube
                gnome-tweaks
                tilix
                gnome-themes-extra
                vlc
                mpv
                firefox
                evolution
                kubectl
                kubernetes-helm
                fluxcd
                terraform
                ansible
                ansible-lint
                # pulumi-bin
                ripgrep
                fd
                chromium
                # ungoogled-chromium
                bitwarden
                # bitwarden-cli
                # bws
                xdotool
                xclip
                pipenv
                obsidian
                # kdePackages.kate
                # kdePackages.konsole
                android-tools
                pmbootstrap
                vscode
                # zed-editor
                # jetbrains.pycharm-community
                meld
                feishin
                cargo
                clippy
                gitui
                openscad
                git
                just
                gcc
                rustc
                pkg-config
                # cura
                openscad
                steam-run
                gnome-boxes
                viddy
                minikube

                python311Packages.mitogen

                # DWM stuff
                rofi
                alacritty
                kitty
                nitrogen
                # xfce-polkit
                # mate.mate-polkit
                autorandr
                # rofi-rbw-x11
                networkmanagerapplet
                pavucontrol
                pulseaudio
                # Hyprland stuff (includes some DWM stuff)
                waybar
                rofi-rbw-wayland
                playerctl

                # Work stuff
                jq
                jqp
                distrobox
                slack
                ocm
                go
                awscli2
                azure-cli
                google-cloud-sdk
                sshuttle
                openshift
                # crc
                # appgate-sdp
              ];
            };

            # Allow unfree packages
            nixpkgs.config.allowUnfree = true;

            # List packages installed in system profile. To search, run:
            # $ nix search wget
            environment.systemPackages = with pkgs; [
              vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
              wget
              helix
              gnumake
              wl-clipboard
              nerdfonts
              python311Full
              python311Packages.virtualenv
              powertop
              killall
              tree

              # XFCE stuff
              # xfce.xfce4-whiskermenu-plugin
              # xfce.xfce4-clipman-plugin

              krb5
            ];
            fonts.packages = with pkgs; [
              nerdfonts
              noto-fonts
              fira-code
              fira-code-symbols
              noto-fonts-emoji
            ];
            time.timeZone = "America/New_York";

            security.polkit.enable = true;
              security.polkit.extraConfig = ''
              polkit.addRule(function(action, subject) {
                if (
                  subject.isInGroup("users")
                    && (
                      action.id == "org.freedesktop.login1.reboot" ||
                      action.id == "org.freedesktop.login1.reboot-multiple-sessions" ||
                      action.id == "org.freedesktop.login1.power-off" ||
                      action.id == "org.freedesktop.login1.power-off-multiple-sessions"
                    )
                  )
                {
                  return polkit.Result.YES;
                }
              })
            '';
            security.pki.certificates = [
              # 2022-IT-Root-CA.pem
              ''
              -----BEGIN CERTIFICATE-----
              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
              56vmq8fwQYIcazjrygWiaOnoep/SMw==
              -----END CERTIFICATE-----
              ''
              # 2015-IT-Root-CA.pem
              ''
              -----BEGIN CERTIFICATE-----
              MIIENDCCAxygAwIBAgIJANunI0D662cnMA0GCSqGSIb3DQEBCwUAMIGlMQswCQYD
              VQQGEwJVUzEXMBUGA1UECAwOTm9ydGggQ2Fyb2xpbmExEDAOBgNVBAcMB1JhbGVp
              Z2gxFjAUBgNVBAoMDVJlZCBIYXQsIEluYy4xEzARBgNVBAsMClJlZCBIYXQgSVQx
              GzAZBgNVBAMMElJlZCBIYXQgSVQgUm9vdCBDQTEhMB8GCSqGSIb3DQEJARYSaW5m
              b3NlY0ByZWRoYXQuY29tMCAXDTE1MDcwNjE3MzgxMVoYDzIwNTUwNjI2MTczODEx
              WjCBpTELMAkGA1UEBhMCVVMxFzAVBgNVBAgMDk5vcnRoIENhcm9saW5hMRAwDgYD
              VQQHDAdSYWxlaWdoMRYwFAYDVQQKDA1SZWQgSGF0LCBJbmMuMRMwEQYDVQQLDApS
              ZWQgSGF0IElUMRswGQYDVQQDDBJSZWQgSGF0IElUIFJvb3QgQ0ExITAfBgkqhkiG
              9w0BCQEWEmluZm9zZWNAcmVkaGF0LmNvbTCCASIwDQYJKoZIhvcNAQEBBQADggEP
              ADCCAQoCggEBALQt9OJQh6GC5LT1g80qNh0u50BQ4sZ/yZ8aETxt+5lnPVX6MHKz
              bfwI6nO1aMG6j9bSw+6UUyPBHP796+FT/pTS+K0wsDV7c9XvHoxJBJJU38cdLkI2
              c/i7lDqTfTcfLL2nyUBd2fQDk1B0fxrskhGIIZ3ifP1Ps4ltTkv8hRSob3VtNqSo
              GxkKfvD2PKjTPxDPWYyruy9irLZioMffi3i/gCut0ZWtAyO3MVH5qWF/enKwgPES
              X9po+TdCvRB/RUObBaM761EcrLSM1GqHNueSfqnho3AjLQ6dBnPWlo638Zm1VebK
              BELyhkLWMSFkKwDmne0jQ02Y4g075vCKvCsCAwEAAaNjMGEwHQYDVR0OBBYEFH7R
              4yC+UehIIPeuL8Zqw3PzbgcZMB8GA1UdIwQYMBaAFH7R4yC+UehIIPeuL8Zqw3Pz
              bgcZMA8GA1UdEwEB/wQFMAMBAf8wDgYDVR0PAQH/BAQDAgGGMA0GCSqGSIb3DQEB
              CwUAA4IBAQBDNvD2Vm9sA5A9AlOJR8+en5Xz9hXcxJB5phxcZQ8jFoG04Vshvd0e
              LEnUrMcfFgIZ4njMKTQCM4ZFUPAieyLx4f52HuDopp3e5JyIMfW+KFcNIpKwCsak
              oSoKtIUOsUJK7qBVZxcrIyeQV2qcYOeZhtS5wBqIwOAhFwlCET7Ze58QHmS48slj
              S9K0JAcps2xdnGu0fkzhSQxY8GPQNFTlr6rYld5+ID/hHeS76gq0YG3q6RLWRkHf
              4eTkRjivAlExrFzKcljC4axKQlnOvVAzz+Gm32U0xPBF4ByePVxCJUHw1TsyTmel
              RxNEp7yHoXcwn+fXna+t5JWh1gxUZty3
              -----END CERTIFICATE-----
              ''
            ];

            services.tailscale.enable = true;

            security.krb5 = {
              enable = true;
              settings = {
                # includedir = ["/etc/krb5.conf.d/"];
                libdefaults = {
                  default_realm = "IPA.REDHAT.COM";
                  dns_lookup_realm = true;
                  dns_lookup_kdc = true;
                  rdns = false;
                  dns_canonicalize_hostname = false;
                  ticket_lifetime = "24h";
                  forwardable = true;
                  udp_preference_limit = 0;
                  default_ccache_name = "KEYRING:persistent:%{uid}";
                };

                realms = {
                  "REDHAT.COM" = {
                      default_domain = "redhat.com";
                      dns_lookup_kdc = true;
                      master_kdc = "kerberos.corp.redhat.com";
                      admin_server = "kerberos.corp.redhat.com";
                  };
                  "IPA.REDHAT.COM" = {
                      default_domain = "ipa.redhat.com";
                      dns_lookup_kdc = true;
                      # Trust tickets issued by legacy realm on this host
                      auth_to_local = "RULE:[1:$1@$0](.*@REDHAT\.COM)s/@.*//";
                      # auth_to_local = "DEFAULT";
                  };
                };
              };
            };

            virtualisation.docker.enable = true;
            virtualisation.podman = {
              enable = true;
              # dockerCompat = true;
              # dockerSocket.enable = true;
              # autoPrune.enable = true;
            };
            virtualisation.libvirtd.enable = true;
            virtualisation.waydroid.enable = true;
            programs.virt-manager.enable = true;

            programs.appgate-sdp.enable = true;

            programs.nix-ld.enable = true;
            programs.nix-ld.libraries = with pkgs; [
              openssl
            ];

            programs.gnome-terminal.enable = true;
            programs.adb.enable = true;

            services.udev.packages = [
              pkgs.android-udev-rules
            ];
            services.flatpak.enable = true;
            xdg.portal.enable = true;
            xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-hyprland];

            programs.nh = {
              enable = true;
              # clean.enable = true;
              # clean.extraArgs = "--keep-since 4d --keep 3";
              # flake = "/home/jericho/nixos-config";
            };

            services.locate = {
              enable = true;
              interval = "hourly";
            };

            services.hardware.bolt.enable = true;
          })
        ];
    };
    packages.x86_64-linux.default = home-manager.defaultPackage.x86_64-linux;

    homeConfigurations = {
      "jericho" = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs { system = "x86_64-linux"; };

        modules = [ ./home.nix ./helix.nix ./hyprland.nix ];
      };
      "runner" = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs { system = "x86_64-linux"; };

        modules = [ ./home.nix ./helix.nix ./hyprland.nix ];
      };
    };

  };
}
