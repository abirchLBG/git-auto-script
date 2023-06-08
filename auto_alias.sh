#!/bin/zsh

# Automatically adds aliases to .zshrc for easier use

filename=~/.zshrc

script_path="$(pwd)/git_script.sh"

echo "Executing commands"

echo "alias \"g.\"=\"zsh $script_path -f"
echo "alias \"g.\"=\"zsh $script_path -f\"" >> $filename

echo "alias \"g..\"=\"zsh $script_path -c"
echo "alias \"g..\"=\"zsh $script_path -c\"" >> $filename

echo "alias \"g...\"=\"zsh $script_path -l"
echo "alias \"g...\"=\"zsh $script_path -l\"" >> $filename

echo "Successfully executed commands"

echo "Sourcing $filename"
source $filename
echo "$filename sourced"
