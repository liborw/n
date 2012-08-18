
notes_todo() {


    if [ "$1" = "--complete" ]; then
        _notes_complete_files
    else
        # Defaults
        INCLUDE_DONE=false
        USAGE="usage: n todo [-dh]"

        # Parse command line options
        args=`getopt dh $*`
        if [ $? != 0 ]; then echo $USAGE; return 1; fi
        set -- $args
        for i; do
            case "$i" in
                -d)
                    INCLUDE_DONE=true
                    ;;
                -h)
                    echo $USAGE
                    return 0
                    ;;
            esac
        done

        # Show todo list
        (cd $NOTES_DIR
        if $INCLUDE_DONE; then
            grep -i @todo *
        else
            grep -i @todo *| \
                grep -v @done
        fi

        )
    fi
}
