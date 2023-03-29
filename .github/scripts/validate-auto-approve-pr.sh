#!/bin/bash

set -e

NUMBER_OF_FILE_CHANGES=$(gh pr diff "$BRANCH" --name-only | wc -l)
if [ $NUMBER_OF_FILE_CHANGES -gt 1 ]; then
  echo "More than one file change please review manually" && exit 1
fi

gh pr diff $BRANCH  --color never |
grep targetRevision |
tail -n1 |
cut -c 2- |
xargs |
grep -Eq "targetRevision: (0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)(?:-((?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*)(?:\.(?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?(?:\+([0-9a-zA-Z-]+(?:\.[0-9a-zA-Z-]+)*))?$"
