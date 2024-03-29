# git-auto-script

## Repository Overview

`git_script.sh` was made for zsh to automate git add, commit, pull, push commands into 1 line with simple syntax.
Additional script includes automatic aliases.

---

## Main Features

1. Reduces git add, commit, push commands to 1 line.
2. With aliasing can be reduced to 2-4 characters (auto-alias script included).
3. Depending on flag message can be:
    1. Pre-fixed with `feat: branch_name`
    2. Pre-fixed with `release:`
    3. Custom
    4. Re-use last commit message
4. Script will automatically check if branch is master/main and ask to continue if true. It can also checkout all changes to a new branch.
5. Script will check if branch is behind, and ask to pull after committing. (Can be set to always pull before pushing.)
6. If no commit message is passed, will ask to pass one.

---

## Instructions

Setting up always pulling before pushing:
`export GIT_SCRIPT_PULL=true`. Alternatively, add line `export GIT_SCRIPT_PULL=true` to `~/.zshrc` , `source ~/.zshrc` .

1. Writing `feat: branch_name` pre-fixed messages (use any)

    * `zsh path/git_script.sh -f`
    * `zsh path/git_script.sh -f suffix msg text`
    * (auto-alias) `g.`
    * (auto-alias) `g. suffix msg text`

    Commit message: `feat: branch_name suffix msg text`

2. Writing `release:` pre-fixed messages (use any)

    * `zsh path/git_script.sh -r`
    * `zsh path/git_script.sh -r suffix msg text`
    * (auto-alias) `g.r`
    * (auto-alias) `g.r suffix msg text`

    Commit message: `release: suffix msg text`

3. Writing custom messages (use any)

    * `zsh path/git_script.sh`
    * `zsh path/git_script.sh custom msg text`
    * `zsh path/git_script.sh -c custom msg text`
    * (auto-alias) `g..`
    * (auto-alias) `g.. custom msg text`

    Commit message: `custom msg text`

4. Re-using last commit message

    Note: Saved commit message is global, and is not specific to a branch or repository.

    * `zsh path/git_script.sh -l`
    * (auto-alias) `g...`

    Commit message: last custom or pre-fixed message used

---

## Auto-alias Script

In this repository is an additional script, `auto_alias.sh`.

Running `sudo zsh auto_alias.sh` from inside repository directory will automatically add aliases to `~/.zshrc` file and source it. It will use current repository path, so if you move it you will need to run the script again to update the paths or just edit the `~/.zshrc` file. This will also back up the `~/.zshrc` file to the current repository.

May need to run `source ~/.zshrc`. If errors executing aliases.

Current aliases added:

1. `alias "g."="zsh path/git-auto-script/git_script.sh -f"`
2. `alias "g.."="zsh path/git-auto-script/git_script.sh -c"`
3. `alias "g..."="zsh path/git-auto-script/git_script.sh -l"`
4. `alias "g.r"="zsh path/git-auto-script/git_script.sh -r"`

This will let you use the aliases mentioned in insctructions.


