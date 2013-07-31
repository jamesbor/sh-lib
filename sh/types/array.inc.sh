typeArrayNew()
{
    local ARRAY_NAME="${1}"
    declare -ag ${ARRAY_NAME}
}

typeArrayPushBack()
{
    local ARRAY_NAME="${1}"
    shift
    if (testVariableExists "${ARRAY_NAME}")
    then
        if (testTypeArray "${ARRAY_NAME}")
        then
            #eval ${ARRAY_NAME}="( `eval echo -n \\${${ARRAY_NAME}[@]}` "$@" )"
            eval ${ARRAY_NAME}="( \"\${${ARRAY_NAME}[@]}\" \"$@\" )"
        fi
    else
        eval ${ARRAY_NAME}="( \"$@\" )"
    fi
}

typeArrayPushFront()
{
    local ARRAY_NAME="${1}"
    shift
    if (testVariableExists "${ARRAY_NAME}")
    then
        if (testTypeArray "${ARRAY_NAME}")
        then
            eval ${ARRAY_NAME}="( \"$@\" \"\${${ARRAY_NAME}[@]}\" )"
        fi
    else
        eval ${ARRAY_NAME}="( \"$@\" )"
    fi
}

typeArrayPopBack()
{
    local ARRAY_NAME="${1}"
    local POSSITION_TO_UNSET="`typeArrayGetIndexLast ${ARRAY_NAME}`"
    echo -n ${ARRAY_NAME[${POSSITION_TO_UNSET}]}
    unset ${ARRAY_NAME}[${POSSITION_TO_UNSET}]
}

typeArrayPopFront()
{
    local ARRAY_NAME="${1}"
    local POSSITION_TO_UNSET="`typeArrayGetIndexFirst ${ARRAY_NAME}`"
    echo -n ${ARRAY_NAME[${POSSITION_TO_UNSET}]}
    unset ${ARRAY_NAME}[${POSSITION_TO_UNSET}]
}

typeArrayPeekBack()
{
    local ARRAY_NAME="${1}"
    echo -n ${ARRAY_NAME[@]: -1}
}

typeArrayPeekFront()
{
    local ARRAY_NAME="${1}"
    local POSSITION_TO_VIEW="`typeArrayGetIndexFirst ${ARRAY_NAME}`"
    echo -n ${ARRAY_NAME}[${POSSITION_TO_VIEW}]
}

typeArrayToString() 
{
    # This will output an array of variables as a string so that it can be stored or passed between things
    # It is more ideal to create a global veriable and pass the refrance between things, but when you have to
    # Martial and re-martial arrays via a string interfact, here you go...
    local ARRAY_NAME="${1}"
    if (testTypeArray "${ARRAY_NAME}") || return $?
    then
        type_report ${ARRAY_NAME} value
    else
        # We have a type that is not an array so returning an error
        return 1
    fi
}

typeArrayToList() 
{
    # This will output an array of variables as a string so that it can be stored or passed between things
    # It is more ideal to create a global veriable and pass the refrance between things, but when you have to
    # Martial and re-martial arrays via a string interfact, here you go...
    local ARRAY_NAME="${1}"
    if (testTypeArray "${ARRAY_NAME}") || return $?
    then
        local -a ARRAY_PROCESS="()"
        ARRAY_PROCESS="`type_report ${ARRAY_NAME} value`"
        for ITEM in ${!ARRAY_PROCESS[@]}
        do
           # echo ${ARRAY_PROCESS[${ITEM}]}
echo $ITEM
        done
    else
        # We have a type that is not an array so returning an error
        return 1
    fi
}

typeArrayGetIndexes()
{
    local ARRAY_NAME="${1}"
    eval echo -n "\${!${ARRAY_NAME}[@]}"
}

typeArrayGetIndexFirst()
{
    local ARRAY_NAME="${1}"
    eval echo -n "\${!${ARRAY_NAME}[@]}" | head -c 1
}

typeArrayGetIndexLast()
{
    local ARRAY_NAME="${1}"
    eval echo -n "\${!${ARRAY_NAME}[@]}" | tail -c 1
}

testTypeArray() 
{
    local ARRAY_NAME="${1}"
    local TYPE_CHECK="`type_report ${ARRAY_NAME} type`"
    if [ "${TYPE_CHECK}" = "-a" -o "${TYPE_CHECK}" = "-A" ]
    then
        # We have a type that is a form of array, lets pass!!
        return 0
    else
        # We have a type that is not an array so returning an error
        return 1
    fi
}

testTypeIndexedArray() 
{
    local ARRAY_NAME="${1}"
    local TYPE_CHECK="`type_report ${ARRAY_NAME} type`"
    if [ "${TYPE_CHECK}" = "-a" ]
    then
        # We have a type that is a form of array, lets pass!!
        return 0
    else
        # We have a type that is not an array so returning an error
        return 1
    fi
}

testTypeAssociativeArray() 
{
    local ARRAY_NAME="${1}"
    local TYPE_CHECK="`type_report ${ARRAY_NAME} type`"
    if [ "${TYPE_CHECK}" = "-A" ]
    then
        # We have a type that is a form of array, lets pass!!
        return 0
    else
        # We have a type that is not an array so returning an error
        return 1
    fi
}
