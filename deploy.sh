#!/bin/sh

# If a command fails then the deploy stops
set -e

printf "\033[0;32mDeploying updates to GitHub...\033[0m\n"

# Build the project.
printf "\033[0;32mBuild the project...\033[0m\n"
hugo

# Go to public folder
printf "\033[0;32mGo to public folder...\033[0m\n"
cd public

# Add changes to git.
printf "\033[0;32mAdd changes to git...\033[0m\n"
git add .

# If we have provided a commit message then use it otherwise use a default.
msg=""
if [ -n "$*" ]; then
	msg="$*"
else
    msg="Rebuilding site $(date)"
fi

# Commit changes.
printf "\033[0;32mCommit changes...\033[0m\n"
git commit -m "$msg"

# Push site.
printf "\033[0;32mPush site...\033[0m\n"
git push origin HEAD:gh-pages

# Go to main folder.
printf "\033[0;32mGo to main folder...\033[0m\n"
cd ../

# Add submodule changes to git.
printf "\033[0;32mAdd submodule changes to git...\033[0m\n"
git add .

# Commit changes.
printf "\033[0;32mCommit changes...\033[0m\n"
git commit -m "Update submodule: $(git rev-parse --short HEAD)"

# Push sources.
printf "\033[0;32mPush sources...\033[0m\n"
git push