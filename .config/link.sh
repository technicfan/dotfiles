#!/bin/bash

if [[ $(pwd) = *"/dotfiles/.config" ]]
then
    while read -r dir
    do
        localdir="$HOME/.config/$(sed 's/.*\///' <<< "$dir")"
        if [[ -d "$localdir" ]]
        then
            mv "$localdir" "$localdir/technicfan-bak"
        fi
        ln -s "$dir" "$localdir"
    done < <(find "$(pwd)" -maxdepth 1 -mindepth 1 -type d)
else
    echo "run in the folder it is located in the repo"
fi