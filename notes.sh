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

    # Tab completion
    if [ "$1" = "--complete" ]; then
        # Diary files
        (cd $NOTES_DIR; ls $2* 2>/dev/null)
        compgen -acdd _diary_$2 | tr -d '_diary_'
        return

    # No parameter given open or create todays note
    elif [ $# -eq 0 ]; then
        FILE_NAME=`date "+$D_FILE_FORMAT"`
    else
        FILE_NAME=$1
    fi

    # Open file
    $D_EDITOR $D_DB_DIR/$D_FILE_NAME

    # Commit changes
    (cd $NOTES_DIR; git add $FILE_NAME; git commit -m "d: `date`")
}

notes_init() {
    echo "It seems that this is a fist time!"
    echo "Creating DB directory: $NOTES_DIR"
    mkdir -R $NOTES_DIR
    (cd $NOTES_DIR; git init)
}

alias n='_n'
complete -C '_n --complete "$COMP_LINE"' n
