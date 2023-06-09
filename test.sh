#!/bin/zsh

branch_name=master
NC=$'\033[0m'
BGreen=$'\033[1;32m'
BRed=$'\033[1;31m'
prefix="[${BGreen}Git-Script${NC}]"

check_status() {
    if [[ $git_status =~ "nothing to commit" ]]; then
        echo "$prefix No changes made. Exiting."
        exit 1
    elif [[ $git_status =~ "Your branch is behind" ]]; then
        read -r "?$prefix Branch is behind '${GReen}$branch_name${NC}'. Git pull (Y/n)? " pull_choice
        case $pull_choice in
            [yY]) pull_status="true" ;;
            [nN]) echo "$prefix Git script terminated.";;
            *) check_status ;;
        esac
    fi
}

check_status