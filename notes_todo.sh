
notes_todo() {


    if [ "$1" = "--complete" ]; then
        echo "-d"
        echo "-h"
    else
        # Defaults
        INCLUDE_DONE=false
        USAGE="usage: n todo [-dh]"

        # Parse command line options
        while getopts hd OPT; do
            case "$OPT" in
                d)
                    INCLUDE_DONE=true
                    ;;
                h)
                    echo $USAGE
                    return 0
                    ;;
                \?)
                    echo $USAGE
                    return 1
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
