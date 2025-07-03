#!/bin/bash

# Group commits by message and squash duplicates

git checkout main
git reset --soft $(git rev-list --max-parents=0 HEAD)

declare -A seen_msgs

for commit in $(git rev-list --reverse HEAD); do
    msg=$(git log -1 --pretty=%B $commit)

    if [[ -n "${seen_msgs[$msg]}" ]]; then
        git reset --soft $commit
        git commit --amend -m "$msg"
    else
        seen_msgs["$msg"]=1
    fi
done