# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.efiSupport = true;

  boot.initrd.luks.devices = [
    {
      name = "root";
      device = "/dev/disk/by-uuid/8d3b4d40-fb39-4064-89b3-ece594cba5f3";
      preLVM = true;
      allowDiscards = true;
    }
  ];

  networking.hostName = "nixos"; # Define your hostname.
  networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.extraResolvconfConf = "resolvconf=NO";
  networking.dnsExtensionMechanism = false; # disable edns0

   #Select internationalisation properties.
   i18n = {
     consoleFont = "Lat2-Terminus16";
     consoleKeyMap = "us";
     defaultLocale = "en_US.UTF-8";
   };

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment = {
     variables = { 
       GOROOT = [ "${pkgs.go.out}/share/go" ]; 
       GOPATH = [ "$HOME/go" ]; 
       EDITOR = [ "vim" ];
     };

      systemPackages = with pkgs; [

        # X
        i3
        xlibs.xbacklight
        xautolock
        xsel
        xterm

        # backup
        restic

        # sysutil
        powertop
        iftop
        htop
        mkpasswd
        unzip

        # dev
        git
        go
        sqlite
        gnumake
        python
        python3

        # audio
        pasystray
        vbam

        # img
        scrot
        zathura 
        sxiv

        # shell
        irssi
        rxvt_unicode
        shellcheck
        screen
        (import ./vim.nix)

        # web
        wget 
        firefox
    ];
  };

  nixpkgs.config = {
    allowUnfree = true;
#    this was just an experiment in pkg overrides.
#    packageOverrides = pkgs:
#      { vbam = pkgs.vbam.override { gtk = pkgs.gtk3; };
#    };
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.bash.enableCompletion = true;
  programs.bash.loginShellInit = ''
    #!${pkgs.bash.out}/bin/bash
    export GOPATH=$HOME/go
    export EDITOR=vim
  '';
  programs.mtr.enable = true;
  programs.gnupg.agent = { 
    enable = true; 
    # enableSSHSupport = true; 
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
   services.openssh.enable = true;
   services.stubby.enable = true;
   services.stubby.listenAddresses = [ "127.0.0.1@8053" "0::1@8053" ];
   services.stubby.extraConfig = ''
   dnssec_return_status: GETDNS_EXTENSION_TRUE
   '';


   services.unbound = {
     enable = true;
     allowedAccess = [
       "192.168.1.1/24"
     ];
     extraConfig = ''
       hide-identity: yes
       hide-version: yes
       qname-minimisation: yes
       harden-short-bufsize: yes
       harden-large-queries: yes
       harden-glue: yes
       harden-dnssec-stripped: yes
       harden-below-nxdomain: yes
       harden-referral-path: yes
       use-caps-for-id: yes
       do-not-query-localhost: no
     forward-zone:
       name: "."
         forward-addr: 127.0.0.1@8053
     '';
   };
   services.cron.enable = true;
   services.cron.systemCronJobs = [
     "0 0 * * * elliot restic backup ~"
   ];

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable the X11 windowing system.
   services.xserver.enable = true;
   services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable touchpad support.
  services.xserver.libinput.enable = true;

  # Enable the KDE Desktop Environment.
  # services.xserver.displayManager.sddm.enable = true;
  # services.xserver.windowManager.xmonad.enable = true;
  services.xserver.windowManager.i3.enable = true;

   services.xserver.displayManager.slim = {
     enable = true;
     theme = pkgs.fetchurl {
       url = "https://github.com/edwtjo/nixos-black-theme/archive/v1.0.tar.gz";
       sha256 = "13bm7k3p6k7yq47nba08bn48cfv536k4ipnwwp1q1l2ydlp85r9d";
     };
   };

   services.xserver.displayManager.sessionCommands = ''
       xrdb "${pkgs.writeText  "xrdb.conf" ''
              URxvt.font:                 xft:Dejavu Sans Mono for Powerline:size=11, xft:Noto Emoji
              XTerm*faceName:             xft:Dejavu Sans Mono for Powerline:size=11, xft:Noto Emoji
              XTerm*utf8:                 2
              URxvt.iconFile:             /usr/share/icons/elementary/apps/24/terminal.svg
              URxvt.letterSpace:          0
              URxvt.background:           #121214
              URxvt.foreground:           #FFFFFF
              XTerm*background:           #121212
              XTerm*foreground:           #FFFFFF
              ! black
              URxvt.color0  :             #2E3436
              URxvt.color8  :             #555753
              XTerm*color0  :             #2E3436
              XTerm*color8  :             #555753
              ! red
              URxvt.color1  :             #CC0000
              URxvt.color9  :             #EF2929
              XTerm*color1  :             #CC0000
              XTerm*color9  :             #EF2929
              ! green
              URxvt.color2  :             #4E9A06
              URxvt.color10 :             #8AE234
              XTerm*color2  :             #4E9A06
              XTerm*color10 :             #8AE234
              ! yellow
              URxvt.color3  :             #C4A000
              URxvt.color11 :             #FCE94F
              XTerm*color3  :             #C4A000
              XTerm*color11 :             #FCE94F
              ! blue
              URxvt.color4  :             #3465A4
              URxvt.color12 :             #729FCF
              XTerm*color4  :             #3465A4
              XTerm*color12 :             #729FCF
              ! magenta
              URxvt.color5  :             #75507B
              URxvt.color13 :             #AD7FA8
              XTerm*color5  :             #75507B
              XTerm*color13 :             #AD7FA8
              ! cyan
              URxvt.color6  :             #06989A
              URxvt.color14 :             #34E2E2
              XTerm*color6  :             #06989A
              XTerm*color14 :             #34E2E2
              ! white
              URxvt.color7  :             #D3D7CF
              URxvt.color15 :             #EEEEEC
              XTerm*color7  :             #D3D7CF
              XTerm*color15 :             #EEEEEC
              URxvt*saveLines:            32767
              XTerm*saveLines:            32767
              URxvt.colorUL:              #AED210

              URxvt.perl-ext:             default,matcher,url-select,selection-to-clipboard,clipboard
              URxvt.keysym.M-u:           perl:url-select:select_next
              URxvt.url-select.launcher:  /run/current-system/sw/bin/chromium
              URxvt.url-select.underline: true

              URxvt.clipboard.autocopy:   true
              URxvt.clipboard.copycmd:    xclip -i -selection clipboard
              URxvt.clipboard.pastecmd:   xclip -o -selection clipboard

              Xft*dpi:                    96
              Xft*antialias:              true
              Xft*hinting:                full
              URxvt.scrollBar:            false
              URxvt*scrollTtyKeypress:    true
              URxvt*scrollTtyOutput:      false
              URxvt*scrollWithBuffer:     false
              URxvt*scrollstyle:          plain
              URxvt*secondaryScroll:      true
              Xft.autohint: 0
              Xft.lcdfilter:  lcddefault
              Xft.hintstyle:  hintfull
              Xft.hinting: 1
              Xft.antialias: 1 
           ''}"
        '';

  # Define a user account. Don't forget to set a password with ‘passwd’.
   # disable because of public source control.
   # users.mutableUsers = false;
   users.extraUsers.elliot = {
     isNormalUser = true;
     uid = 1000;
     extraGroups = [ "wheel" ];
     # generated with mkpasswd -m sha-512. redacted for public src ctrl.
     # hashedPassword = "";
   };

   fonts = {
       enableFontDir = true;
       enableGhostscriptFonts = true;
       fonts = with pkgs; [
         anonymousPro
         corefonts
         dejavu_fonts
         font-droid
         freefont_ttf
         google-fonts
         noto-fonts
         noto-fonts-cjk
         noto-fonts-emoji
         inconsolata
         liberation_ttf
         powerline-fonts
         source-code-pro
         terminus_font
         ttf_bitstream_vera
         ubuntu_font_family
       ];
     };

   systemd.user.services."urxvtd" = {
     enable = true;
     description = "rxvt unicode daemon";
     wantedBy = [ "default.target" ];
     path = [ pkgs.rxvt_unicode ];
     serviceConfig.Restart = "always";
     serviceConfig.RestartSec = 2;
     serviceConfig.ExecStart = "${pkgs.rxvt_unicode}/bin/urxvtd -q -o";
   };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "17.09"; # Did you read the comment?
  hardware = {
    pulseaudio.enable = true;
  };
}
