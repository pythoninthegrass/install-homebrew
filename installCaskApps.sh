#!/usr/bin/env bash


# Exit upon failed command
# set -e

# Logs
logTime=$(date +%Y-%m-%d:%H:%M:%S)
removeENSLog="/tmp/removeENSLog_$logTime.log"
exec &> >(tee -a "$removeENSLog")

# Current user
loggedInUser=$(ls -l /dev/console | cut -d " " -f 4)

# Working directory
scriptDir=$(cd "$(dirname "$0")" && pwd)

# Check for root privileges
# if [ $(whoami) != "root" ]; then
#     echo "Sorry, you need super user privileges to run this script."
#     exit 1
# fi

# Call brew install
if [ ! -e "/usr/local/Homebrew" ]; then
    ( exec "$scriptDir/installHomebrew.sh" )
fi

# Set $IFS to eliminate whitespace in pathnames
IFS="$(printf '\n\t')"

# Run on Mac with existing apps
# ToDo: Return only app name via regex
# system_profiler SPApplicationsDataType | grep -E 'Obtained from: Identified Developer|Mac App Store|Unknown' | awk '{print $1}'

# Apps to install
declare -a brewArray=(
    # Use system_profiler above to compile list
)
# echo $stopArray

# Install ALL THE THINGS
for a in "${brewArray[@]}"; do
    echo "Installed $a."
    [ -f "$a" ] && brew cask install "$a"
done

unset IFS

# Reboot
echo "Restarting now. Hit CTRL-C to cancel."
sleep 5s
sudo reboot
