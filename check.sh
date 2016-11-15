#!/bin/sh

awk '/^  "/ { print }' cmd/create_iam_accounts.py | sed 's/^  "//' | sed 's/".*$//' \
    > done.txt

if [ ! -d homebrew ]; then
    git clone https://github.com/Homebrew/homebrew.git
else
    cd homebrew
    git pull origin master
    cd "$OLDPWD"
fi
ls homebrew/Library/Formula/ | sed 's/\.py$//' > homebrew.txt

diff done.txt homebrew.txt | grep -v '^[0-9]' | \
    sed 's/^< /Deleted: /' | sed 's/^> /Added: /'

