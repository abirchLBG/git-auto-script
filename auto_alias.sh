#!/bin/zsh

# Automatically adds aliases to .zshrc for easier use

filename=~/.zshrc

script_path="$(pwd)/git_script.sh"

echo "Backing up ~/.zshrc"
cp $filename $(pwd)/.zshrc_backup

echo "Appending aliases to $filename"

echo "alias \"g.\"=\"zsh $script_path -f"
echo "alias \"g.\"=\"zsh $script_path -f\"" >> $filename

echo "alias \"g..\"=\"zsh $script_path -c"
echo "alias \"g..\"=\"zsh $script_path -c\"" >> $filename

echo "alias \"g...\"=\"zsh $script_path -l"
echo "alias \"g...\"=\"zsh $script_path -l\"" >> $filename

echo "Successfully appended aliases"

echo "Sourcing $filename"
source $filename
echo "$filename sourced"
echo "Auto-alias script finished successfully"
