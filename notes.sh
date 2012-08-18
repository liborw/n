# Simple command line diary

# @TODO: Plugins
# @TODO: Search

_n() {

    # Configuration
    NOTES_DIR=~/Documents/Log
    NOTES_FILE_FORMAT='%Y-%m-%d'
    NOTES_EDITOR=vim

    # Check if DB directory exist
    if [ ! -d $NOTES_DIR ]; then
        notes_init
    fi

    if [ "$1" = "--complete" ]; then
        # Tab completion
        shift
        # Commands
        for line in $(compgen -ac "notes_$1" | sed 's/^notes_//'); do
            echo $line
        done
        # Notes
        for line in $(cd $NOTES_DIR; ls $1* 2>/dev/null); do
            echo $line
        done
        return

    elif [ $# -eq 0 ]; then
        # No parameter given open or create todays note
        FILE_NAME=`date "+$NOTES_FILE_FORMAT"`
    else
        # Maybe command maybe file to open.
        CMD=notes_$1
        hash $CMD 2>/dev/null
        if [ $? -eq 0 ]; then
            shift
            $CMD $@
            return
        else
            FILE_NAME=$1
        fi
    fi

    # Open file
    $NOTES_EDITOR $NOTES_DIR/$FILE_NAME

    # Commit changes
    (cd $NOTES_DIR; git add $FILE_NAME; git commit -m "d: `date`")
}

notes_todo() {
    (cd $NOTES_DIR; grep -ie "@todo" * | grep -v @done)
}

notes_grep() {
    (cd $NOTES_DIR; grep $@)
}

notes_init() {
    echo "It seems that this is a fist time!"
    echo "Creating DB directory: $NOTES_DIR"
    mkdir -R $NOTES_DIR
    (cd $NOTES_DIR; git init)
}



alias n='_n'
complete -C '_n --complete "$COMP_LINE"' n
