type_list_humamize_reference()
{
    # This function is for pluralising statements based on the contents of an IFS seperated list
    # i.e. $ echo "The argument`type_list_pluralise "${ARGUMENTS}"` were empty" which echo either 
    # The argument
    if [ "$#" -gt "1" ]
    then
        echo "are"
    elif [ "$#" -eq "1" ]
    then
        echo "is"
    fi
}

type_list_pluralize()
{
    # This function is for pluralizing statements based on the contents of an IFS seperated list
    # i.e. $ echo "The argument`type_list_pluralize "${ARGUMENTS}"` were empty" which echo either 
    # The argument or The arguments depending on if there is more than one in the list
    if [ "$#" -gt "1" ]
    then
        echo -n "s"
    fi
}

type_list_inversepluralize()
{
    # As with the non inverse version, but inverted, i.e. things are pluralized if theere is only one
    if [ "$#" -eq "1" ]
    then
        echo -n "s"
    fi
}

type_list_humanize()
{
    # This funciton returns all arguments passed to it as a list for human consumtion
    # e.g. 1 (or) 5, 4 & 6 (or) apples, grapes, berrys and other fruit
    local -i ARG_COUNT=$#
    local -i ARG_POS=1
    if [ "${ARG_COUNT}" -eq "1" ]
    then
        echo "${1}"
    else
        for ARGUMENT in "$@"
        do
            if [ "$#" -gt "2" ]
            then
                echo -n "${ARGUMENT}, "
                shift
            elif [ "$#" -eq "2" ]
            then
                echo -n "${ARGUMENT} & "
                shift
            elif [ "$#" -eq "1" ]
            then
                echo "${ARGUMENT}"
                shift
            fi 
        done
    fi
}

typeListAdd()
{
    local LIST_NAME="${1}"
    shift
#set -x
    if [ -z "`eval echo \\${${LIST_NAME}}`" ]
    then
        #eval ${LIST_NAME}=\""${1}"\"
 #       eval echo ${LIST_NAME}=\""${1}"\"
        eval ${LIST_NAME}="\"$@\""
    else
        #eval ${LIST_NAME}=\""\$${LIST_NAME} \"${1}\""\"
#        eval echo ${LIST_NAME}=\""\$${LIST_NAME}"" ""${1}"\"
        eval ${LIST_NAME}="\$${LIST_NAME} \"$@\""
    fi
#set +x
}
