#!/bin/zsh

check_status() {
    git_status=$(git status)
    echo "st $git_status"
}

check_status