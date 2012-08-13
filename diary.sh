# Simple command line diary

d() {

    # Configuration
    D_DB_DIR=~/Documents/Log
    D_FILE_FORMAT='%Y_%m_%d'
    D_EDITOR=vim
    D_GREP='grep --color=auto'

    # Check if DB directory exist
    if [ ! -d $D_DB_DIR ]; then
        echo "Creating DB directory: $D_DB_DIR"
        mkdir $D_DB_DIR
        (cd $D_DB_DIR; git init)
    fi

    # Tab completion
    if [ "$1" = "--complete" ]; then
        echo "Not yet implemented"
        return
    fi

    # Grep search
    if [ "$1" = "--grep" ]; then
        shift
        ( cd $D_DB_DIR; $D_GREP $@ *)
        return
    fi

    # No parameter given open or create todays note
    if [ $# -eq 0 ]; then
        D_FILE_NAME=`date "+$D_FILE_FORMAT"`
    else
        D_FILE_NAME=$1
    fi

    # Open file
    $D_EDITOR $D_DB_DIR/$D_FILE_NAME

    # Commit changes
    (cd $D_DB_DIR; git add $D_FILE_NAME; git commit -m "d: `date`")

}
