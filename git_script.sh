#!/bin/zsh

NC=$'\033[0m'
BGreen=$'\033[1;32m'
BRed=$'\033[1;31m'
prefix="[${BGreen}Git-Script${NC}]"


input_args=""
branch_name=""

# Checks if commit msg is empty
check_empty_msg() {
    msg_type="$1"
    input_args_msg="${@:2}"
    while [ -z "$input_args_msg" ]; do
        if [ "$msg_type" = "c" ]; then
            read -r "?$prefix (CUSTOM) Please enter a commit message: " input_args_msg
        else
            read -r "?$prefix (PRE-FIXED) Please enter a commit message: " input_args_msg
        fi
    done
    echo "$input_args_msg"
}

# (Not actually main lmao)
main() {
    main_args_list=$@
    if [ $# -eq 0 ]; then
        input_args=$(check_empty_msg "c" "$*") 
        echo "$input_args" > "./last_commit_msg.txt"
        custom_msg "$input_args"
    else
        while getopts ":cfl" flag; do
            case "$flag" in

                # custom msg
                c) msg="${main_args_list[@]:3}"
                    msg=$(check_empty_msg "c" "$msg")
                    echo "$msg" > "./last_commit_msg.txt"
                    custom_msg "$msg";;

                # feat: branch_name prefix
                f) msg="${main_args_list[@]:3}"
                    msg=$(check_empty_msg "f" "$msg")
                    msg="feat: $branch_name $msg"
                    echo "$msg" > "./last_commit_msg.txt"
                    custom_msg "$msg";;

                # last used msg
                l) msg=$(cat ./last_commit_msg.txt)
                    msg=$(check_empty_msg "c" "$msg")
                    custom_msg "$msg";;
                
                # default case
                \?) echo "$prefix Invalid flag passed. Exiting."
                    exit 1;;
            esac
        done
        echo "$main_args_list" > "./last_commit_msg.txt"
        custom_msg "$main_args_list"
    fi
}

# (main) Function to check if the branch is master/main
check_branch() {
    branch_name=$(git rev-parse --abbrev-ref HEAD)
    if [[ "$branch_name" = "master" || "$branch_name" = "main" ]]; then
        read -r "?$prefix Current branch is '${BRed}$branch_name${NC}'. Continue (Y/n)? " choice
        case $choice in
            [yY]) main $@ ;;
            [nN]) echo "$prefix Git script terminated.";;
            *) check_branch "$*" ;;
        esac
    fi
}

# Fucntion to execute git commands
custom_msg() {
    # echo "git add -A"
    # echo "git commit -m \"$*\""
    # echo "git push"
    git add -A
    git commit -m \"$*\"
    git push
    echo "$prefix Git script finished successfully!"
    exit 1
}

# main() func call
check_branch $@
