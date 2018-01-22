#!/bin/bash

# Check if one parameter was provided as input
if [[ $# -ne 1 ]];
then
    echo "Usage: $0 <input-filepath>";

    exit 1;
fi

# Check if the provided input filepath points to a regular file
if [[ ! -f $1 ]];
then
    echo "The provided input file path does not point to a regular file. Please change.";

    exit 1;
fi

# Create a temporary file for storing the contents of the file excluding empty lines
temporaryFile=$(mktemp) || exit 1;

# Copy the non-empty lines to the temporary file
cat $1 | egrep "^[^\n\r]" > ${temporaryFile}

# Replace the original with the temporary file
mv ${temporaryFile} $1;
