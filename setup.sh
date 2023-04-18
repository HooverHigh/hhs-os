#!/bin/bash

# Check if Git is installed
if ! [ -x "$(command -v git)" ]; then
  echo 'Error: Git is not installed.' >&2
  exit 1
fi

# Check system architecture
case $(uname -m) in
  x86_64)
    machine="amd64"
    echo "Building for $(uname)"
    ;;
  armv7l)
    if [ -f /sys/firmware/devicetree/base/model ]; then
      if grep -qi 'Raspberry Pi' /sys/firmware/devicetree/base/model; then
        echo "Building for Raspberry Pi."
      fi
    fi
    machine="arm"
    ;;
  aarch64)
    machine="arm64"
    echo "Building for $(uname)"
    ;;
  *)
    echo "Error: Unsupported system architecture $(uname -m). While it may be possible to run pi-gen on this system, it is not officially supported and may result in unexpected behavior." >&2
    exit 1
    ;;
esac

# Loop through file with URLs and Git clone each one
while read url; do
  basename=$(basename "$url")
  echo "Cloning $basename..."
  git clone "$url"
done < repos
