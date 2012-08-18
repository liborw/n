# Simple command line diary

_n() {

    # Configuration
    D_DB_DIR=~/Documents/Log
    D_FILE_FORMAT='%Y-%m-%d'
    D_EDITOR=vim
    D_GREP='grep --color=auto'

    # Check if DB directory exist
    if [ ! -d $D_DB_DIR ]; then
        echo "Creating DB directory: $D_DB_DIR"
        mkdir $D_DB_DIR
        (cd $D_DB_DIR; git init)

    # Tab completion
    elif [ "$1" = "--complete" ]; then
        # Diary files
        (cd $D_DB_DIR; ls $2* 2>/dev/null)
        compgen -ac _diary_$2 | tr -d '_diary_'
        return

    # Grep search
    elif [ "$1" = "search" ]; then
        shift
        ( cd $D_DB_DIR; $D_GREP $@ *)
        return

    elif [ "$1" = "open" ]; then
        shift
        _diary_open $@
        echo $D_TEST
        return

    # No parameter given open or create todays note
    elif [ $# -eq 0 ]; then
        D_FILE_NAME=`date "+$D_FILE_FORMAT"`
    else
        D_FILE_NAME=$1
    fi

    # Open file
    $D_EDITOR $D_DB_DIR/$D_FILE_NAME

    # Commit changes
    (cd $D_DB_DIR; git add $D_FILE_NAME; git commit -m "d: `date`")
}

notes_open() {
    echo $D_GREP
    D_TEST="ahoj"
}


alias n='_n'
complete -C '_n --complete "$COMP_LINE"' n
