#!/bin/sh

renameFilesForDirectory ()
{
    cd "$1"

    for i in *"$TEMPLATE_APP_NAME"*
    do
        if [ -f "$i" ] || [ -d "$i" ];
        then
            # Check
            # Rename the file
            OLDNAME="$i"
            NEWNAME=`echo $i | sed -e s/"$TEMPLATE_APP_NAME"/"$NEW_APP_NAME"/g`
            #Only add the new file if it doesn't already exist
            if [[ -e "$NEWNAME" ]];
            then
                echo ignore file "$OLDNAME" \("$NEWNAME" already exists\)
            else
                # Specifically replace 'path = OLDNAME' with 'path = "NEWNAME"'
                echo mv "$OLDNAME" "$NEWNAME"
                mv "$OLDNAME" "$NEWNAME"
            fi
        fi
    done

    for d in *
    do
        if [ -d "$d" ];
        then
            ( renameFilesForDirectory "$d" )
        fi
    done

}

applySedInDirectory ()
{
    SEDARG="$1"

    # For each file in directory, replace OLD with NEW
    for f in *
    do
        if [ -d "$f" ];
        then
            cd "$f"
            echo "$f": applySedInDirectory "$SEDARG"
            applySedInDirectory "$SEDARG"
            cd ..
        elif [ "$SCRIPTNAME" = "$f" ];
        then
            #do nothing - don't touch this script
            echo "Don't replace words in this script"
        elif [ -f "$f" -a -r "$f" ];
        then

            SPLIT_ARRAY=(${f//./ })
            LENGTH=${#SPLIT_ARRAY[@]} # Get the length.
            LAST_POSITION=$((LENGTH - 1)) # Subtract 1 from the length.
            FILE_EXTENSION=${SPLIT_ARRAY[${LAST_POSITION}]} # Get the last position.

            EXT_MATCH="false"

            for ext in "${RENAMED_IGNORED_FILES_ARRAY[@]}"; do
                if [ ".$FILE_EXTENSION" == "$ext" ]; then
                    EXT_MATCH="true"
                    break
                fi
            done

            if [ "$EXT_MATCH" == "false" ]; then
                echo "sed $SEDARG $f > $TFILE && mv $TFILE $f"
                sed "$SEDARG" "$f" > $TFILE && mv $TFILE "$f"
            else
                echo "Not using sed on $f"
            fi
        else
            echo "Error: Cannot read $f"
        fi
    done
}

if [ $# != 2 ];
then
 echo "Usage: ./"$0" currentAppName newAppName"
 exit 1
fi

declare -a RENAMED_IGNORED_FILES_ARRAY=(".gem" ".a" ".mobileprovision" ".png" ".jpg")

TEMPLATE_APP_NAME="$1"
NEW_APP_NAME="$2"

renameFilesForDirectory .

#save the temp file's name in a variable
TFILE="/tmp/out.tmp.$$"
SCRIPTNAME=$(basename "$0")

echo applySedInDirectory s/$TEMPLATE_APP_NAME/$NEW_APP_NAME/g
applySedInDirectory "s/$TEMPLATE_APP_NAME/$NEW_APP_NAME/g"

if [ -e "$TFILE" ];
then
  /bin/rm "$TFILE"
fi