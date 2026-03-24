#!/bin/bash

remove_by_extension() {
    if [ $# -eq 0 ]; then
        echo "Usage: remove_by_extension <extension> [-r] [directory]"
        return 1
    fi
    
    ext="${1#.}"
    dir="${3:-.}"
    
    if [ "$2" = "-r" ]; then
        find "$dir" -name "*.$ext" -type f -delete
    else
        find "$dir" -maxdepth 1 -name "*.$ext" -type f -delete
    fi
}
