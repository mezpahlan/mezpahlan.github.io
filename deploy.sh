#!/bin/sh

# If a command fails then the deploy stops
set -e

printf "\033[0;32mDeploying updates to GitHub...\033[0m\n"

# Build the project.
hugo

# Go To Public folder
cd public

# Add changes to git.
git add .

# If we have provided a commit message then use it otherwise use a default.
msg=""
if [ -n "$*" ]; then
	msg="$*"
else
    msg="Rebuilding site $(date)"
fi

# Commit changes.
git commit -m "$msg"

# Push site.
git push

# Go to Main folder.
cd ../

# Add submodule changes to git.
git add .

# Commit changes.
git commit -m "Update submodule: $(git rev-parse --short HEAD)"

# Push sources.
git push