#!/bin/bash

if [[ $(pwd) = *"/dotfiles/.config" ]]
then
    while read -r dir
    do
        if ! [[ -d "$HOME/.config/$(sed 's/.*\///' <<< "$dir")" ]]
        then
            ln -s "$dir" "$HOME/.config/$(sed 's/.*\///' <<< "$dir")"
        fi
    done < <(find "$(pwd)" -maxdepth 1 -mindepth 1 -type d)
else
    echo "run in the folder it is located in the repo"
fi