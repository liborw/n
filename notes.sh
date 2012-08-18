# Simple command line diary

# @TODO: Plugins
# @TODO: Search

# Source commands
_notes_load_cmd() {
    local DIR="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    for file in $(ls $DIR/notes_*); do
        . $file
    done
}
_notes_load_cmd

_notes_complete_commands() {
    for line in $(compgen -ac "notes_$1" | sed 's/^notes_//'); do
        echo $line
    done
}

_notes_complete_files() {
    for line in $(cd $NOTES_DIR; ls $1* 2>/dev/null); do
        echo $line
    done
}

_notes_complete() {
    local prev=${COMP_WORDS[1]}
    local cur=${COMP_WORDS[COMP_CWORD]}
    local line=( ${COMP_LINE} )
    local opts

    # Check whether is this a command
    local executable=notes_$prev
    hash $executable 2>/dev/null
    if [ $? -eq 0 ]; then
        opts=`$executable --complete ${line[@]:2}`
    else
        opts=`_notes_complete_commands;_notes_complete_files`
    fi
    COMPREPLY=($(compgen -W "${opts}" -- ${cur}))
}

_n() {

    # Configuration
    NOTES_DIR=~/Documents/Log
    NOTES_FILE_FORMAT='%Y-%m-%d'
    NOTES_EDITOR=vim

    # Check if DB directory exist
    if [ ! -d $NOTES_DIR ]; then
        notes_init
    fi

    if [ $# -eq 0 ]; then
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


notes_grep() {
    (cd $NOTES_DIR; grep $@)
}

notes_init() {
    echo "It seems that this is a fist time!"
    echo "Creating DB directory: $NOTES_DIR"
    mkdir -R $NOTES_DIR
    (cd $NOTES_DIR; git init)
}

notes_cmptest() {

    if [ "$1" = "--complete" ]; then
        shift
        echo $@
    fi
    echo $@
}


alias n='_n'
complete -F _notes_complete n
