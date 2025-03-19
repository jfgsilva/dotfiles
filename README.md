# dotfiles
My dotfiles

# tmux
## install tmux plugin manager

```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
# type this in terminal if tmux is already running
tmux source ~/.tmux.conf
```

# gitconfig
Have a look at the following youtube talk [so you think you know git](https://www.youtube.com/watch?v=aolI_Rz0ZqY&t=2224s)
## some basic configuration
[gist](https://gist.github.com/schacon)
## better branch script
```bash
#!/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
NO_COLOR='\033[0m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
NO_COLOR='\033[0m'

width1=5
width2=6
width3=30
width4=20
width5=40

# Function to count commits
count_commits() {
    local branch="$1"
    local base_branch="$2"
    local ahead_behind

    ahead_behind=$(git rev-list --left-right --count "$base_branch"..."$branch")
    echo "$ahead_behind"
}

# Main script
main_branch=$(git rev-parse HEAD)

printf "${GREEN}%-${width1}s ${RED}%-${width2}s ${BLUE}%-${width3}s ${YELLOW}%-${width4}s ${NO_COLOR}%-${width5}s\n" "Ahead" "Behind" "Branch" "Last Commit"  " "

# Separator line for clarity
printf "${GREEN}%-${width1}s ${RED}%-${width2}s ${BLUE}%-${width3}s ${YELLOW}%-${width4}s ${NO_COLOR}%-${width5}s\n" "-----" "------" "------------------------------" "-------------------" " "


format_string="%(objectname:short)@%(refname:short)@%(committerdate:relative)"
IFS=$'\n'

for branchdata in $(git for-each-ref --sort=-authordate --format="$format_string" refs/heads/ --no-merged); do
    sha=$(echo "$branchdata" | cut -d '@' -f1)
    branch=$(echo "$branchdata" | cut -d '@' -f2)
    time=$(echo "$branchdata" | cut -d '@' -f3)
    if [ "$branch" != "$main_branch" ]; then
            # Get branch description
            description=$(git config branch."$branch".description)
            
            # Count commits ahead and behind
            ahead_behind=$(count_commits "$sha" "$main_branch")
            ahead=$(echo "$ahead_behind" | cut -f2)
            behind=$(echo "$ahead_behind" | cut -f1)
            
            # Display branch info
	    printf "${GREEN}%-${width1}s ${RED}%-${width2}s ${BLUE}%-${width3}s ${YELLOW}%-${width4}s ${NO_COLOR}%-${width5}s\n" $ahead $behind $branch "$time" "$description"
    fi
done


```

# old but goodies
## git blame
```bash
# git blame just a little
git blame -L 15,26 path/to/file
# ignore white space and ignore movement
git blame -w -C
```

## git log
```bash
# git log just a little
git log -L 15,26 path/to/file
```

## pickaxe
```bash
# It's useful for tracking when and where a particular string or code snippet was introduced or removed.
git log -S files_watcher -p
```
## diff
```bash
# find changes on lines word per word
git diff --word-diff
```

## record fixing automatically for future cases
```bash
git config --global rerere.enabled true
```

## push
```bash
# only force push if someone didn t push something first
git push --force-with-lease
```

## git maintenance
```bash
git maintenance start
```
