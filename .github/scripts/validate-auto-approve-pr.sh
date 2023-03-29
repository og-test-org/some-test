#!/bin/bash

set -e

NUMBER_OF_FILE_CHANGES=$(gh pr diff "$BRANCH" --name-only | wc -l)
if [ $NUMBER_OF_FILE_CHANGES -gt 1 ]; then
  echo "More than one file change! Please review manually" && exit 1
fi

echo "Reviewing PR version update"
TARGET_REVISION=$(gh pr diff $BRANCH  --color never |
grep targetRevision |
tail -n1 |
cut -c 2- |
xargs |
sed -e "s/^targetRevision: //")

TARGET_REVISION_REGEX="^(0|[1-9][0-9]*)\\.(0|[1-9][0-9]*)\\.(0|[1-9][0-9]*)(\\-[0-9A-Za-z-]+(\\.[0-9A-Za-z-]+)*)?(\\+[0-9A-Za-z-]+(\\.[0-9A-Za-z-]+)*)?$"
if [[ $TARGET_REVISION =~ $TARGET_REVISION_REGEX ]];
then
    echo "TARGET_REVISION '$TARGET_REVISION' matches TARGET_REVISION_REGEX '$TARGET_REVISION_REGEX'"
else
    echo "TARGET_REVISION '$TARGET_REVISION' DOES NOT MATCH TARGET_REVISION_REGEX '$TARGET_REVISION_REGEX'"
    echo "Validation unsuccessful"
    exit 1
fi

echo "Validation successful"
