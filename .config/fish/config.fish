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
        for repo in $repos
            echo $repo
            cd "$repodir/$repo"
            git pull
            echo
            cd -
        end
    end

    if test "$TERM" = "xterm-kitty"
        alias ssh='kitten ssh'
    else
        alias ssh='TERM=xterm-256color /bin/ssh'
    end

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

    alias secret="openssl rand -base64 48"

    fish_add_path /home/technicfan/.spicetify
    fish_add_path /home/technicfan/GitHub/l7-dmenu-desktop
    fish_add_path /home/technicfan/Github/spotifyd/target/release

    zoxide init --cmd cd fish | source
    #starship init fish | source

end
