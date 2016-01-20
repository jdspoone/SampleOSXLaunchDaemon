#!/bin/sh

# Unload the daemon
launchctl unload /Library/LaunchDaemons/com.example.daemon.plist

# Remove the daemon's launchd.plist
rm /Library/LaunchDaemons/com.example.daemon.plist

# Remove the daemon's executable
rm /Library/PrivilegedHelperTools/LaunchDaemon