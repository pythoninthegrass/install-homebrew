#!/bin/sh

# Taken from https://www.jamf.com/jamf-nation/discussions/6999/deploying-homebrew-through-casper
# Original credit before cosmetic differences goes to the user jesseshipley

# Getting Username
loggedInUser=$(ls -l /dev/console | cut -d " " -f 4)

# Modifying permissions and creating directories
chmod g+rwx /usr/local
chgrp admin /usr/local
mkdir /Library/Caches/Homebrew
chmod g+rwx /Library/Caches/Homebrew
chown -R $loggedInUser /Library/Caches
chmod g+rwx /usr/local/bin
chgrp admin /usr/local/bin

# Downlading and installing Homebrew
cd /usr/local
git init -q
git config remote.origin.url https://github.com/Homebrew/brew
git fetch origin master:refs/remotes/origin/master -n
git reset --hard origin/master
chown -R $loggedInUser $(ls | grep -v bin)
chown $loggedInUser /usr/local/bin/brew
chgrp admin /usr/local/bin/brew

# Creating .bash_profile with new path but checking there isn't one already
if [ ! -f /Users/$loggedInUser/.bash_profile ]; then
    sudo -u $loggedInUser echo "PATH=/usr/local/bin:$PATH" >> /Users/$loggedInUser/.bash_profile
fi
