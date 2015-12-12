#!/bin/bash

APP_DOWNLOAD_URL="https://hipchat.com/downloads/latest/mac"

APP_ZIP_PATH="/tmp/HipChat.app.zip"
APP_UNZIP_DIRECTORY="/tmp"
APP_UNZIPPED_PATH="/tmp/HipChat.app/"
APP_PATH="/Applications/HipChat.app/"
APP_RELATIVE_INFO_PLIST="Contents/Info.plist"
APP_PROCESS_NAME="HipChat"

rm -rf "$APP_ZIP_PATH" "$APP_UNZIPPED_PATH"
/usr/bin/curl --retry 3 -L "$APP_DOWNLOAD_URL" -o "$APP_ZIP_PATH"
/usr/bin/unzip -q "$APP_ZIP_PATH" -d "$APP_UNZIP_DIRECTORY"
if pgrep "$APP_PROCESS_NAME"; then
  printf "Error: %s is currently running!\n" "$APP_PROCESS_NAME"
else
  if [ -d "$APP_PATH" ]; then
    appVersion=$(defaults read "$APP_PATH$APP_RELATIVE_INFO_PLIST" CFBundleShortVersionString)
    printf "Removing $APP_PROCESS_NAME version %s\n" "$appVersion"
    rm -rf "$APP_PATH"
  fi
  mv -f "$APP_UNZIPPED_PATH" "$APP_PATH"
  chown -R root:wheel "$APP_PATH"
  appVersion=$(defaults read "$APP_PATH$APP_RELATIVE_INFO_PLIST" CFBundleShortVersionString)
  printf "Installed $APP_PROCESS_NAME version %s\n" "$appVersion"
  rm -f "$APP_ZIP_PATH" "$APP_UNZIPPED_PATH"
fi