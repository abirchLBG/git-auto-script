#!/bin/zsh

# Instructions

# Script will automatically check if branch is master/main and ask to continue if true
# Will automatically overwrite last commit message to a txt file ./last_commit_msg.txt
# If no commit message passed, it will ask you to put one in (all use cases except last message mode)

# For better usability, add aliases into ~/.zshrc file e.g. `alias "g."="zsh ~/script_name.sh -f"`
# Refresh .zshrc via >source ~/.zshrc
# To call the script you can now do >g. msg text


# Writiing custom messages:
# >zsh script_name.sh
# >zsh script_name.sh custom msg text
# >zsh script_name.sh -c custom msg text

# Writing 'feat: branch_name' pre-fixed messages
# >zsh script_name.sh -f
# >zsh script_name.sh -f suffix msg text

# Writing last used commit message
# >zsh script_name.sh -l


input_args=""
branch_name=""

# Checks if commit msg is empty
check_empty_msg() {
    msg_type="$1"
    input_args_msg="${@:2}"
    while [ -z "$input_args_msg" ]; do
        if [ "$msg_type" = "c" ]; then
            read -r "?Please enter a commit message: " input_args_msg
        else
            read -r "?(PRE-FIXED) Please enter a commit message: " input_args_msg
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
                \?) echo "Invalid flag passed"
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
        read -r "?Current branch is '$branch_name'. Continue (Y/n)? " choice
        case $choice in
            [yY]) main $@ ;;
            [nN]) echo "Terminating Git script. exit code 1";;
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
    exit 1
}

# main() func
check_branch $@
