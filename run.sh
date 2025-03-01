 #!/usr/bin/env bash

# This line is finding and storing the absolute directory path of the script that's currently running. 
# Let me break down how it works from the inside out:
# ${BASH_SOURCE[0]} - This is a Bash variable that contains the path to the current script file as it was called.
# The [0] index refers to the current script (as opposed to any scripts that might have sourced this one).

# dirname "${BASH_SOURCE[0]}" - The dirname command extracts just the directory portion of a path. 
# So if your script is at /home/user/scripts/myscript.sh, this would return /home/user/scripts.

# cd $(dirname "${BASH_SOURCE[0]}") - This changes the directory to the script's directory.
# The $() syntax executes the command inside and substitutes its output.
# script_dir=$(cd $(dirname "${BASH_SOURCE[0]}")) - This attempts to assign the output of the cd command to the variable script_dir.

# However, there's an issue with this line - the cd command doesn't actually output anything, so script_dir would be empty. 
# The pwd command (which stands for "print working directory") is used in this context to get the absolute path of the directory after the cd command has changed to the script's directory.
# Here's why it's necessary:

# The dirname "${BASH_SOURCE[0]}" part might give you a relative path like ./scripts or ../bin depending on how the script was called.
# The cd command changes to that directory, but doesn't output anything.
# By running pwd after the cd, you get the absolute (full) path of that directory as it exists in the filesystem.
script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
filter="$1"
echo "$script_dir"

