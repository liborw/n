
# Edit multiple notes at once.
# !e:file -- Edit file, i.e. rewrite all content.
# !a:file -- Append file
# !# ...  -- Ignored

notes_multi() {


    if [ "$1" = "--complete" ]; then
        _notes_complete_files
    else
        # Defaults
        USAGE="usage: n multi [-h]"
        TMPFILE=.N_MULTI_NOTE

        # Parse command line options
        args=`getopt h $*`
        if [ $? != 0 ]; then echo $USAGE; return 1; fi
        eval set -- $args
        while true; do
            case "$1" in
                -h)
                    echo $USAGE
                    return 0
                    ;;
                --)
                    shift
                    break
                    ;;
            esac
        done

        # Create temporary file
        if [ $# -eq 0 ]; then
            local FILENAME=`date "+$NOTES_FILE_FORMAT"`
            echo "!e:$FILENAME"
            cat $NOTES_DIR/$FILENAME >>$TMPFILE 2>/dev/null
        else
            for file in $(cd $NOTES_DIR; ls $@); do
                echo "!e:$file" >>$TMPFILE
                cat $NOTES_DIR/$file >>$TMPFILE 2>/dev/null
            done
        fi

        # Open tmp file in editor
        $NOTES_EDITOR $TMPFILE

        # Parse tmp file
        local EDITED_FILES=""
        local TARGET_FILE="/dev/null"
        cat $TMPFILE | while read line; do
            if [[ "$line" = !a:* ]]; then
                TARGET_FILE=${line:3}
                EDITED_FILES="$TARGET_FILE $EDITED_FILES"
            elif [[ "$line" = !e:* ]]; then
                TARGET_FILE=${line:3}
                :> $NOTES_DIR/$TARGET_FILE
                EDITED_FILES="$TARGET_FILE $EDITED_FILES"
            else
                echo $line >>$NOTES_DIR/$TARGET_FILE
            fi
        done

        # Commit changes
        (cd $NOTES_DIR; git add $EDITED_FILES; git commit -m "multi: `date`")

        # Delete file
        rm $TMPFILE
    fi
}
