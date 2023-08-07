#!/bin/zsh

# Print formatting
NC=$'\033[0m'
BGreen=$'\033[1;32m'
BRed=$'\033[1;31m'
BYellow=$'\033[1;33m'
BBlue=$'\033[1;34m'
BOLD=$(tput bold)
NOT_BOLD=$(tput sgr0)
prefix="[${BGreen}Git-Script${NC}]"
red_prefix="[${BRed}Git-Script${NC}]"
yellow_prefix="[${BYellow}Git-Script${NC}]"


input_args=""
branch_name=""
branch_name=$(git rev-parse --abbrev-ref HEAD)
git_status=$(git status)
pull_status=${GIT_SCRIPT_PULL:-"false"}
script_loc=${0:a:h}


# Checks if commit msg is empty
check_empty_msg() {
    msg_type="$1"
    input_args_msg="${@:2}"
    while [ -z "$input_args_msg" ]; do
        if [ "$msg_type" = "c" ]; then
            read -r "?$yellow_prefix ${BOLD}(CUSTOM)${NOT_BOLD} Please enter a commit message: " input_args_msg
        elif [ "$msg_type" = "f" ]; then
            read -r "?$yellow_prefix ${BOLD}(PRE-FIXED)${NOT_BOLD} Please enter a commit message: " input_args_msg
        elif [ "$msg_type" = "r" ]; then
            read -r "?$yellow_prefix ${BOLD}(PRE-FIXED)${NOT_BOLD} Please enter a commit message: " input_args_msg
        fi
    done
    echo "$input_args_msg"
}


# (Not actually main)
# The naming origin of this function is a widely debated topic amongst historians.
main() {
    if [ "$pull_status" = "false" ]; then
        check_status
    fi
    main_args_list=$@
    if [ $# -eq 0 ]; then
        input_args=$(check_empty_msg "c" "$*") 
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
                l) msg=$(cat $script_loc/last_commit_msg.txt)
                    msg=$(check_empty_msg "c" "$msg")
                    custom_msg "$msg";;

                # release: branch_name prefix
                r) msg="${main_args_list[@]:3}"
                    msg=$(check_empty_msg "r" "$msg")
                    msg="release: $msg"
                    custom_msg "$msg";;
                
                # default case
                \?) echo "$red_prefix Invalid flag passed. Exiting."
                    echo ""
                    exit 1;;
            esac
        done
        custom_msg "$main_args_list"
    fi
}

checkout_to_new_branch() {
    new_branch_name=""
    while [ -z "$new_branch_name" ]; do
        read -r "?$yellow_prefix Enter new branch name to checkout to: " new_branch_name
    done

    checkout_status=""
    if [ ! -z "$new_branch_name" ]; then
        checkout_status=$(git checkout -b "$new_branch_name")
    fi
}


# (main) Function to check if the branch is master/main
check_branch() {
    # echo "INFO: check_branch() called"
    if [[ "$branch_name" = "master" || "$branch_name" = "main" ]]; then
        read -r "?$yellow_prefix Current branch is '${BRed}$branch_name${NC}'. Continue ${BOLD}(y/n/(C)heckout)${NOT_BOLD}? " choice
        case $choice in
            [yY]) main $@ ;;
            [nN]) echo "$red_prefix Git script terminated.";;
            [cC]) checkout_to_new_branch ;; 
            *) check_branch "$*" ;;
        esac
    else 
        main $@
    fi
}


# Fucntion to execute git commands
custom_msg() {
    git add -A | sed 's/^/    /'
    git commit -m $* | sed 's/^/    /'
    echo "$msg" > "$script_loc/last_commit_msg.txt"
    if [ "$pull_status" = "true" ]; then
        echo "$prefix Executing git pull."
        git pull
    fi
    git push --quiet | sed 's/^/    /'
    status_check=$(git status)
    time_finish=$(date +%H:%M:%S)
    if [[ "$status_check" =~ "up to date" ]]; then
        echo "$prefix Current branch is now up to date with remote ("$time_finish")."
    else
        echo "$prefix Git push finished, but branch is not up to date with remote. Pulling. ("$time_finish")"
        git pull
    fi
    echo "$prefix ${BGreen}Finished successfully!${NC}"
    echo ""
    exit 0
}


check_status() {

    if [[ $git_status =~ "Your branch is ahead" ]]; then
        read -r "?$yellow_prefix Branch is ahead '${BGreen}$branch_name${NC}'. Git push ${BOLD}(Y/n)${NOT_BOLD}? " push_choice
        case $pull_choice in
            [yY]) git push ;;
            [nN]) echo "$prefix Git script terminated."
                    echo ""
                    exit 0;;
            *) check_status ;;
        esac

    elif [[ $git_status =~ "Your branch is behind" ]]; then
        read -r "?$yellow_prefix Branch is behind '${BGreen}$branch_name${NC}'. Git pull ${BOLD}(Y/n)${NOT_BOLD}? " pull_choice
        case $pull_choice in
            [yY]) pull_status="true" ;;
            [nN]) echo "$prefix Git script terminated."
                    echo ""
                    exit 0;;
            *) check_status ;;
        esac

    elif [[ $git_status =~ "nothing to commit" ]]; then
        echo "$prefix No changes made. Exiting."
        exit 0
    fi
}

echo ""
echo "$prefix ${BOLD}Starting Git-Script.${NOT_BOLD}"
# main() func call
check_branch $@

