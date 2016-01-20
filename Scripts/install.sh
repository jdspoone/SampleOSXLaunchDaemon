#!/bin/sh

PROJECT_DIR=$1
BUILT_PRODUCTS_DIR=$2

# Copy the daemon's launchd.plist into /Library/LaunchDaemons
for plist in daemon-Launchd.plist
do
  trg=/Library/LaunchDaemons/com.example.daemon.plist
  cp ${PROJECT_DIR}/LaunchDaemon/${plist} ${trg}
  chown root:wheel ${trg}
  chmod 644 ${trg}
done

# Copy the daemon's executable into /Library/PrivilegedHelperTools
for executable in LaunchDaemon
do
  trg=/Library/PrivilegedHelperTools/${executable}
  cp ${BUILT_PRODUCTS_DIR}/${executable} ${trg}
  chown -R root:admin ${trg}
done

# Load the new daemon
launchctl load /Library/LaunchDaemons/com.example.daemon.plist
