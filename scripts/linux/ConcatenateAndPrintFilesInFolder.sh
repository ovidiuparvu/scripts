#!/bin/bash

###############################################################################
#
# Script for concatenating all files in a folder and printing them
#
##############################################################################


# If the number of parameters provided to the script is different from 1
if [ $# != 1 ];
then
    echo "Please input the path to the folder containing the files to be printed.";
else
    # If the provided parameter does point to a directory
    if [ -d $1 ];
    then
        # Construct concatenation command
        catCommand="cat ";

        # Consider only regular files
        for filename in `find $1 -type f | sort`;
        do
            catCommand="${catCommand} ${filename}";
        done

        # Print files
        ${catCommand} | lpr;
    else
        echo "The parameter provided to the script is not a folder. Please change.";
    fi  
fi
