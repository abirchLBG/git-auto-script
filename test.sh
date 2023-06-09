#!/bin/zsh

check_status() {
    git_status=$(git status)
    echo "st $git_status"
    if [[ "nothing to commit" = *"$git_status"* ]]; then
        echo "No changes made"
    else
        echo "changes made"
    fi
}

check_status