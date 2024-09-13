if status --is-interactive

    set fish_greeting
    fastfetch
    echo

    function yy
    	set tmp (mktemp -t "yazi-cwd.XXXXXX")
    	yazi $argv --cwd-file="$tmp"
    	if set cwd (cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
    		cd -- "$cwd"
    	end
    	rm -f -- "$tmp"
    end

    function up
        yay
        echo
        flatpak update
        echo
        pull
        spicetify upgrade
    end

    function pull
        set repodir "$HOME/git-repos"
        set -l repos $(ls $repodir)
        for repo in $repos
            echo $repo
            cd "$repodir/$repo"
            git pull
            echo
            cd -
        end
    end

    alias fishconfig='micro ~/.config/fish/config.fish'
    alias alacrittyconfig='micro ~/.config/alacritty/alacritty.toml'
    alias menvironment='sudo micro /etc/environment'

    alias in='yay -S'
    alias re='yay -R'
    alias re-f='yay -Rns'
    alias re-d='yay -Rs'
    alias se='yay -Ss'
    alias se-l='pacman -Qs'

    alias fin='flatpak install'
    alias fre='flatpak remove'
    alias fse='flatpak search'
    alias fup='flatpak update'

    # git
    alias clone='cd ~/git-repos && git clone'

    # save rm
    alias rm='trash'

    # bat
    alias cat='bat'

    # figlet (always forgetting name)
    alias asciiart='figlet'

    alias bg-f='feh --bg-fill'

    alias vsc='vscodium'

    alias icon-color='~/.config/qtile/scripts/icon-color.sh'

    alias venin='sudo vencordinstallercli'

    # fix nano/vim in ssh due to $TERM being alacritty on host
    alias ssh='TERM=xterm-256color /bin/ssh'

    # iso and version used to install ArcoLinux
    alias iso="cat /etc/dev-rel"

    # push microG to /priv/app
    alias pushgms="bash -c 'if [ -f \"gmscore.apk\" ]; then adb root && adb disable-verity && adb remount && adb push gmscore.apk /system/priv-app/GmsCore.apk && adb enable-verity && adb reboot; \
                    else echo \"place the latest microG release as 'gmscore.apk' in current directory\"; fi'"
    alias startshizuku="adb shell sh /sdcard/Android/data/moe.shizuku.privileged.api/start.sh"

    fish_add_path /home/technicfan/.spicetify
    fish_add_path /opt/lampp
    fish_add_path /home/technicfan/GitHub/l7-dmenu-desktop
    fish_add_path /home/technicfan/.cache/lm-studio/bin
    fish_add_path /home/technicfan/.local/bin
    fish_add_path /home/technicfan/Github/spotifyd/target/release

    zoxide init --cmd cd fish | source
    #starship init fish | source

end
