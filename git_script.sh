#!/bin/zsh

# Print formatting
NC=$'\033[0m'
BGreen=$'\033[1;32m'
BRed=$'\033[1;31m'
BOLD=$(tput bold)
NOT_BOLD=$(tput sgr0)
prefix="[${BGreen}Git-Script${NC}]"


input_args=""
branch_name=""
branch_name=$(git rev-parse --abbrev-ref HEAD)
git_status=$(git status)
pull_status="false"
script_loc=${0:a:h}


# Checks if commit msg is empty
check_empty_msg() {
    msg_type="$1"
    input_args_msg="${@:2}"
    while [ -z "$input_args_msg" ]; do
        if [ "$msg_type" = "c" ]; then
            read -r "?$prefix (CUSTOM) Please enter a commit message: " input_args_msg
        elif [ "$msg_type" = "f" ]; then
            read -r "?$prefix (PRE-FIXED) Please enter a commit message: " input_args_msg
        elif [ "$msg_type" = "r" ]; then
            read -r "?$prefix (PRE-FIXED) Please enter a commit message: " input_args_msg
        fi
    done
    echo "$input_args_msg"
}


# (Not actually main. The naming origin of this function is debated amongs historians.)
main() {
    check_status
    main_args_list=$@
    if [ $# -eq 0 ]; then
        input_args=$(check_empty_msg "c" "$*") 
        echo "$input_args" > "./last_commit_msg.txt"
        custom_msg "$input_args"
    else
        while getopts ":cflr" flag; do
            case "$flag" in

                # custom msg
                c) msg="${main_args_list[@]:3}"
                    msg=$(check_empty_msg "c" "$msg")
                    custom_msg "$msg";;

                # feat: branch_name prefix
                f) msg="${main_args_list[@]:3}"
                    msg=$(check_empty_msg "f" "$msg")
                    msg="feat: $branch_name $msg"
                    custom_msg "$msg";;

                # last used msg
                l) msg=$(cat ./last_commit_msg.txt)
                    msg=$(check_empty_msg "c" "$msg")
                    custom_msg "$msg";;

                # release: branch_name prefix
                r) msg="${main_args_list[@]:3}"
                    msg=$(check_empty_msg "r" "$msg")
                    msg="release: $msg"
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
    # echo "INFO: check_branch() called"
    if [[ "$branch_name" = "master" || "$branch_name" = "main" ]]; then
        read -r "?$prefix Current branch is '${BRed}$branch_name${NC}'. Continue ${BOLD}(Y/n)${NOT_BOLD}? " choice
        case $choice in
            [yY]) main $@ ;;
            [nN]) echo "$prefix Git script terminated.";;
            *) check_branch "$*" ;;
        esac
    else 
        main $@
    fi
}


# Fucntion to execute git commands
custom_msg() {
    git add -A
    git commit -m $*
    echo "$msg" > "$script_loc/last_commit_msg.txt"
    if [ "$pull_status" = "true" ]; then
        git pull
    fi
    git push
    echo "$prefix Git script finished successfully!"
    exit 1
}


check_status() {
    # echo "INFO: check_status() called"
    if [[ $git_status =~ "Your branch is behind" ]]; then
        read -r "?$prefix Branch is behind '${BGreen}$branch_name${NC}'. Git pull ${BOLD}(Y/n)${NOT_BOLD}? " pull_choice
        case $pull_choice in
            [yY]) pull_status="true" ;;
            [nN]) echo "$prefix Git script terminated."
                    exit 1;;
            *) check_status ;;
        esac
    elif [[ $git_status =~ "nothing to commit" ]]; then
        echo "$prefix No changes made. Exiting."
        exit 1
    fi
}



echo "$prefix Starting Git-Script"
# main() func call
check_branch $@

