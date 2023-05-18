#!/bin/bash

# Function to traverse directories recursively
traverse_directories() {
    local current_dir="$1"

    # Loop through all directories and files in the current directory
    for item in "$current_dir"/*; do
        if [ -d "$item" ]; then
            local item_name=$(basename "$item")

            if [ "$item_name" == "hhos" ]; then
                if [ "$run_hhos_build" == true ] && [ -f "$item/build.sh" ]; then
                    echo "Running build.sh in $item..."
                    (cd "$item" && ./build.sh)
                fi
            else
                # If the item is a directory (excluding "hhos"), cd into it and check for the script
                cd "$item"
                if [ -f "build.sh" ]; then
                    echo "Running build.sh in $item..."
                    ./build.sh
                fi
                # Recursively call the function to traverse the subdirectories
                traverse_directories "$item"
                # Go back to the previous directory
                cd ..
            fi
        fi
    done
}

# Set the main directory as the current directory
main_directory="$(pwd)"

# Determine whether to run the build.sh script for hhos based on the provided argument
if [ "$1" == "all" ]; then
    run_hhos_build=true
elif [ "$1" == "projects" ]; then
    run_hhos_build=false
else
    echo "Building all"
    run_hhos_build=true
fi

# Traverse the main directory and its subdirectories
traverse_directories "$main_directory"

echo "Finished building $1."
