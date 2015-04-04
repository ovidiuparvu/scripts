#!/bin/bash

###############################################################################
#
# Replace the first argument with the second argument in the provided file
#
###############################################################################

# Check if the required parameters were provided as input

if [[ $# -ne 3 ]];
then
    echo "Usage: $0 <search-words> <replace-words> <file>.";
    
    exit 1;
fi

# Check if the provided file path is valid

if [[ ! -f $3 ]];
then
    echo "The provided file path $3 is not valid. Please change.";
    
    exit 1;
fi

# Replace inline all occurrences of <search-words> with <replace-words> in file

sed -i".bak" "s/$1/$2/g" $3 && rm ${3}.bak;
