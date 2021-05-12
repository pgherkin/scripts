#!/bin/bash
#
# run this script with a path as the 1st arguement
# it will extract all files from subdirs
# renaming them with the name of the parent folder
#
# for example
# ./moveUp.sh ~/Downloads/MediaCollection
#
# ~/Downloads/MediaCollection/Media-01.12.16/dfEr43GFG.mkv
# becomes
# ~/Downloads/MediaCollection/Media-01.12.16.mkv
#
# and the folder moved to a to-be-deleted folder
#
#
[ $# -eq 0 ] && { echo "Usage: $0 path"; exit 1; }

read -p "Is this the correct path: $1 [y/n] " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]
then

cd $1

#
CDIR="./to-be-deleted"
mkdir $CDIR


# find all directories within the path provided, looping through each (excluding del dir)
find ./* -maxdepth 0 -type d -not -path $CDIR | while read DIR; do 

    # find the largest file
    find "$DIR" -maxdepth 1 -type f -printf "%s\t%p\n" | sort -n | tail -1 | awk '{print $2}'| while read FILE; do

        # find the file extention of that file
	    EXT="${FILE##*.}"

        # check to see if a file in the parent dir already exists with that name
        if [[ -f "$DIR.$EXT" ]]; then
            # if so add a random number to its name and move to parent dir
        	mv "$FILE" "$DIR.$RANDOM.$EXT"
        else
            # otherwise move straight to parent dir
            mv "$FILE" "$DIR.$EXT"
        fi
        # move remaing folder to clearup dir
        mv "$DIR" "$CDIR/"
    done;


done;

fi
