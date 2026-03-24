#!/bin/bash

rm_tail() {
    if [ $# -eq 0 ]; then
        echo "Usage: rm_tail <filename_tail> [-r] [directory]"
        return 1
    fi
    
    tail="$1"
    dir="."
    depth=(-maxdepth 1)
    action="-delete"

    shift # Remove `$1` from `$@` so we can loop through remaining args

    for arg in "$@"; do
        case "$arg" in
            -r) depth=() ;;
            --dry) action="-print" ;;
            *) dir="$arg" ;;
        esac
    done

    find $dir ${depth[@]} -name "*$tail" -type f $action
}
