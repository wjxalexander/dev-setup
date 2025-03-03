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
filter=""
dry="0"

while [[ $# > 0 ]]; do # $# represents the number of arguments
    if [[ $1 == '--dry' ]]; then
        dry="1"
    else
        filter="$1"
    fi
    shift # remove the 1st argument from arguments list
done

# declare a funciton
log(){
    if [[ $dry == "1" ]]; then
        echo "[DRY_RUN]: $@" #"[DRY_RUN]:" followed by all arguments passed to the function ($@).
    else 
        echo "$@"
    fi
}

# declare a funciton
execute(){
    log "goint to exectute $@" #The log function is called with "execute" 
    if [[ $dry == "1" ]]; then
       return
    fi
    "$@" #$@: exec everything
}
log "$script_dir -- $filter"

# This command uses the find utility to search for files in a specific directory with a set of filters. Let me break it down:

# find ./runs - Start searching in the directory named "runs" that's in your current directory (the ./ prefix means "current directory").
# -maxdepth 1 - Only look at files/directories directly inside the "runs" directory without going into any subdirectories. This limits the search to just one level deep.
# -mindepth 1 - Only look at items that are at least one level below the starting point. This excludes the "runs" directory itself from the results.
# -executable - Only find files that have executable permissions (files that you can run as programs).
# -type f - Only include regular files in the results, not directories, symbolic links, or other special file types.
# scripts=$(find ./runs -maxdepth  1 -mindepth 1 -executable -type f) #get all scripts The GNU version of find (commonly found on Linux) supports the -executable option,
scripts=$(find ./runs -maxdepth  1 -mindepth 1 -perm +0111)
#"If the content of the $script variable does NOT contain the string 'filter', then execute the following commands in the conditional block."
# echo "$script" - This outputs the contents of the variable named script.
# | - This is a pipe that takes the output from the left command and sends it as input to the right command.
# grep -qv "filter" - This uses the grep tool with specific options:
# -q: Quiet mode - suppresses normal output (doesn't print matching lines)
# -v: Invert match - finds lines that do NOT contain the pattern
# "filter": The pattern to search for (in this case, the literal word "filter")

for script in $scripts; do
    if echo "$script" | grep -qv "$filter"; then 
        log "filtering $script"
        continue
    fi

    execute ./$script #This line only executes if the previous condition was false 
done


