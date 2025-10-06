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
        echo
        spicetify upgrade
    end

    function pull
        echo Aktualisiere Git-Repositories ...
        set repodir "$argv"
        set -l repos $(ls $repodir)
        set -l args
        for repo in $repos
            if test -d "$repodir/$repo/.git"
                set -a args "$repodir/$repo"
            end
        end
        parallel '
            function git_pull;
                cd "$argv";
                git fetch 2>/dev/null;
                if [ "$(git rev-parse @)" != "$(git rev-parse @{u})" ];
                    set output "$(echo $argv | sed "s/^.*\///" && git -c color.ui=always pull 2>/dev/null || return)";
                    echo \n$output;
                end;
            end;
            git_pull {};
        ' ::: $args
    end

    function ssh
        set host $(grep "host" ~/.config/fish/ssh-config | sed 's/host=//')
        set name $(grep "name" ~/.config/fish/ssh-config | sed 's/name=//')
        set user $(grep "user" ~/.config/fish/ssh-config | sed 's/user=//')
        set id_file $(grep "id_file" ~/.config/fish/ssh-config | sed 's/id_file=//')
        if test "$TERM" = "xterm-kitty"
            set command 'kitten ssh'
        else
            set command 'TERM=xterm-256color /bin/ssh'
        end
        if string match -q "$name*" = $argv
            set number $(echo "$argv" | sed "s/$name//")
        end
        if string match -q "$name*" = $argv
            eval $command -i "$id_file" "$user@$name$number.$host"
        else
            eval $command $argv
        end
    end

    alias v='nvim'
    alias fishconfig='nvim ~/.config/fish/config.fish'
    alias alacrittyconfig='nvim ~/.config/alacritty/alacritty.toml'
    alias menvironment='sudoedit /etc/environment'

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
    alias fli='flatpak list'
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

    # nvme temp
    alias nvme_temp='sudo nvme smart-log /dev/ng0n1 | grep -e "^.emperature" | awk -F ": " \'{ print $2 }\' | awk \'{ print $1" "$2 }\''

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

    set -gx SSH_AUTH_SOCK $HOME/.bitwarden-ssh-agent.sock
    # set -gx SSH_AUTH_SOCK $HOME/.goldwarden-ssh-agent.sock

    zoxide init --cmd cd fish | source
    #starship init fish | source

end
