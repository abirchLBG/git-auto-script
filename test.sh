#!/bin/zsh

check_status() {
    git_status=$(git status)
    echo "st $git_status"
    if [[ $git_status =~ "nothing to commit" ]]; then
        echo "No changes made"
    else
        echo "changes made"
    fi
}

check_status