#!/bin/bash

# Set the default value for the CONF variable
CONF=""

# Check if the script is being run from the "hhs-os" directory
if [ "$(basename "$(dirname "$0")")" == "hhs-os" ]; then
    CONF="$(dirname "$0")/hhos/confs/default"
    cd "$(dirname "$0")/hhos"
else
    echo "Please run this script in the 'hhs-os' root directory."
    exit 1
fi

# Parse the command-line arguments
while getopts "c:" option; do
    case "$option" in
        c)
            CONF="$OPTARG"
            ;;
        *)
            echo "Invalid option: $option"
            ;;
    esac
done

# Run the build.sh script with the provided CONF option
./build.sh -c "$CONF"
