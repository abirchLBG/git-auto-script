#!/bin/zsh

# Automatically adds aliases to .zshrc for easier use

NC=$'\033[0m'
BGreen=$'\033[1;32m'
prefix="[${BGreen}Auto-Alias${NC}]"

filename=~/.zshrc

script_path="$(pwd)/git_script.sh"

echo "$prefix Backing up ~/.zshrc"
cp $filename $(pwd)/.zshrc_backup

echo "$prefix Appending aliases to $filename"

echo "$prefix alias \"g.\"=\"zsh $script_path -f"
echo "alias \"g.\"=\"zsh $script_path -f\"" >> $filename

echo "$prefix alias \"g.r\"=\"zsh $script_path -r"
echo "alias \"g.r\"=\"zsh $script_path -r\"" >> $filename

echo "$prefix alias \"g..\"=\"zsh $script_path -c"
echo "alias \"g..\"=\"zsh $script_path -c\"" >> $filename

echo "$prefix alias \"g...\"=\"zsh $script_path -l"
echo "alias \"g...\"=\"zsh $script_path -l\"" >> $filename

echo "$prefix Successfully appended aliases"

echo "$prefix Sourcing $filename"
source $filename
echo "$prefix $filename sourced"
echo "$prefix Auto-alias script finished successfully"
