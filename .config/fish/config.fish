if status --is-interactive

    set fish_greeting
    fastfetch
    echo

    function up
        yay
        echo
        fup
        echo
        pull "$HOME/git-repos"
        spicetify upgrade
    end

    function pull
        set repodir "$argv"
        set -l repos $(ls $repodir)
        set -l output
        for repo in $repos
            if test -d "$repodir/$repo/.git"
                set -a output "$repo" $(git -C "$repodir/$repo" pull &)
            end
        end
        echo $output
    end

    if test "$TERM" = "xterm-kitty"
        alias ssh='kitten ssh'
    else
        alias ssh='TERM=xterm-256color /bin/ssh'
    end

    alias v='nvim'
    alias fishconfig='nvim ~/.config/fish/config.fish'
    alias alacrittyconfig='nvim ~/.config/alacritty/alacritty.toml'
    alias menvironment='sudo nvim /etc/environment'

    alias venv='python -m venv'

    alias in='yay -S'
    alias re='yay -R'
    alias re-f='yay -Rns'
    alias re-d='yay -Rs'
    alias se='yay -Ss'
    alias se-l='pacman -Qs'

    alias fin='flatpak install'
    alias fre='flatpak remove'
    alias fse='flatpak search'
    alias fup='sudo flatpak update'

    # quit (nvim)
    alias :q='exit'

    # git
    alias clone='cd ~/git-repos && git clone'

    # save rm
    alias rm='trash'

    # ls
    alias ls='lsd'

    # bat
    alias cat='bat'

    # figlet (always forgetting name)
    alias asciiart='figlet'

    alias bg-f='feh --bg-fill'

    alias vsc='vscodium'

    alias icon-color='~/.config/qtile/scripts/icon-color.sh'

    alias venin='sudo vencordinstallercli'

    # iso and version used to install ArcoLinux
    alias iso="cat /etc/dev-rel"

    # push microG to /priv/app
    alias pushgms="bash -c 'if [ -f \"gmscore.apk\" ]; then adb root && adb disable-verity && adb remount && adb push gmscore.apk /system/priv-app/GmsCore.apk && adb enable-verity && adb reboot; \
                    else echo \"place the latest microG release as 'gmscore.apk' in current directory\"; fi'"
    alias startshizuku="adb shell sh /sdcard/Android/data/moe.shizuku.privileged.api/start.sh"

    alias spicetify_perms='sudo chmod a+wr /var/lib/flatpak/app/com.spotify.Client/x86_64/stable/active/files/extra/share/spotify && sudo chmod a+wr -R /var/lib/flatpak/app/com.spotify.Client/x86_64/stable/active/files/extra/share/spotify/Apps'

    alias secret="openssl rand -base64 48"

    alias tlmgr="sudo /usr/local/texlive/2025/bin/x86_64-linux/tlmgr"

    fish_add_path /home/technicfan/.spicetify
    fish_add_path /home/technicfan/GitHub/l7-dmenu-desktop
    fish_add_path /home/technicfan/Github/spotifyd/target/release
    fish_add_path /usr/local/texlive/2025/bin/x86_64-linux/

    zoxide init --cmd cd fish | source
    #starship init fish | source

end
