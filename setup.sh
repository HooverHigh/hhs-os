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

# Function to traverse directories recursively
traverse_directories() {
    local current_dir="$1"

    # Loop through all directories and files in the current directory
    for item in "$current_dir"/*; do
        if [ -d "$item" ]; then
            # If the item is a directory, cd into it and check for the script
            cd "$item"
            if [ -f "install-deps.sh" ]; then
                echo "Running install-deps.sh in $item..."
                ./install-deps.sh
            fi
            # Recursively call the function to traverse the subdirectories
            traverse_directories "$item"
            # Go back to the previous directory
            cd ..
        fi
    done
}

# Loop through file with URLs and Git clone each one
while read line; do
  url=$(echo "$line" | cut -d "|" -f 1)
  branch=$(echo "$line" | cut -d "|" -f 2)
  if [ -z "$branch" ]; then
    echo "Cloning $url..."
    git clone "$url"
  else
    echo "Cloning $url with branch $branch..."
    git clone --branch "$branch" "$url"
  fi

  # Extract the repository name from the URL
  repo_name=$(basename "$url" ".git")

  # Traverse into the cloned repository and run install-deps.sh if found
  echo "Installing $repo_name's dependencies:"
  traverse_directories "$repo_name"
  echo "Finished installing $repo_name's dependencies."
done < repos

echo "All subprojects downloaded and dependencies installed."
echo "To build all projects and then build the os, run: \"build.sh all\", to just build the projects and not the os, run: \"build.sh projects\""
