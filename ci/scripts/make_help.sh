#!/bin/bash


# Set colors
col_off='\033[0m'
target_col='\033[36m'
variable_col='\033[93m'
grey='\033[90m'


help(){
    # Display usage information
    echo "Usage:"
    printf " make %b[target]%b %b[variables]%b\n\n" "$target_col" "$col_off" "$variable_col" "$col_off" 

    _help_targets "$1"
    _help_variables "$1"
    _help_examples "$1"
}

_help_targets(){
    local pattern
    pattern='^[a-zA-Z0-9._-]+:.*?##.*$'

    echo "Target(s):"
    grep -E "$pattern" "$1" | sort | while read -r line; do
        target=${line%%:*}
        if [[ $target == "arg_filter" ]]; then
            continue
        fi
        description=${line#*##}
        printf "  %b%-30s%b%s\n" "$target_col" "$target" "$col_off" "$description"
    done
    echo ""
}

_help_variables(){
    local pattern 
    pattern='^[a-zA-Z0-9_-]+[:?|+]?=.*?##.*$'

    echo "variable(s):"
    grep -E "$pattern" "$1" | sort | while read -r line; do
        variable=${line%% *}
        default=${line#*= }
        default=${default%%##*}
        description=${line##*## }
        printf "  %b-30s%b%s \n" "$variable_col" "$variable" "$col_off" "$description" # %b(default: %s)%b | "$grey" "$default" "$col_off"
    done
    echo ""
}

_help_examples(){
    echo "Example(s):"
    echo "$ make build"
}

help "$1"
exit 0