type_report() 
{
    test_number_args "1|2" $@			|| return $?
    local VARIABLE_NAME="${1}"
    local OUTPUT_MODE="${2}"
    local EXIT_STATE=""
    local TYPE
    local TYPE_HUMAN
    local DECLARE_OUTPUT
    local EXPORTboolean
    local READONLYboolean
    local FUNCTIONboolean
    if (test_arg_exists "-\?" "$@")
    then
        echo "usage: $0 [VARIABLE NAME] [RUN TYPE] [-? | --help]"
        echo
        return 10
    elif (test_arg_exists "--help" "$@")
    then
        echo
        echo " Type Report Function:"
        echo " ---------------------"
        echo " usage: $0 [VARIABLE NAME] [RUN TYPE] [-? | --help]"
        echo
        echo " Help Options:"
        echo " [-?] | [--help] usage or this detailed help screen"
        echo " [VARIABLE NAME] general query for consumption by a human"
        echo " [VARIABLE NAME] [RUN TYPE] where the following run types are accepted:"
        echo " ( value    )  To return the value of the variable/function"
        echo " ( type     )  To return the type of the variable/function"
        echo " ( human    )  To return the type of the variable/function in human readable format"
        echo " ( export   )  To return (true/false) depending on if the variable is set to be exported"
        echo " ( readonly )  To return (true/false) depending on if the variable is set to be read only"
        echo " ( function )  To return (true/false) depending on if the variable is set to be function"
        echo " ( detail   )  To return all detail for computer consumption with the following columns:"
        echo " ( columns  )  To return the following column field headings:"
        echo
        echo -e "[TYPE FLAG]\t[TYPE HUMAN]\t[SET TO EXPORT]\t[SET READ ONLY]\t[FUNCTION?]"
        return 10
    fi
    local -a DECLARE_OUTPUT="`declare -p ${VARIABLE_NAME} 2>/dev/null`"
    EXIT_STATE="${?}"
    DECLARE_OUTPUT="${DECLARE_OUTPUT#'declare '}"			# Lets strp off the word 'decalre ' with trailing space from the start of the var
    TYPE="`echo ${DECLARE_OUTPUT} | awk '{print $1}'`"
    DECLARE_OUTPUT="${DECLARE_OUTPUT#${TYPE} ${VARIABLE_NAME}=}"	# Lets strp off the TYPE, VARABLE_NAME and an '='
    while [[ "${TYPE}" =~ [xr]$ ]]
    do
        # We have a flag to process, as caught by the previous regex
        case "${TYPE: -1}" in		# Lets check the last char of the TYPE field for an 'x'
        "x")
            debugecho "This variable is set for export!"
            EXPORTboolean="true"
            TYPE="${TYPE%${TYPE: -1}}"	# Now we have recorded its relevance, lets strip the 'x'
            ;;
        "r")
            debugecho "This variable is set as read only!"
            READONLYboolean="true"
            TYPE="${TYPE%${TYPE: -1}}"	# Now we have recorded its relevance, lets strip the 'r'
            ;;
        *)
            echo " ERROR!: Something wrong with regex used to catch flags"
            ;;
        esac
    done
    if [ "${EXIT_STATE}" -eq "0" ]
    then
        # We have a variable, lets test if is is an array
        case "${TYPE}" in
        "--"|"-")
            debugecho "We have an general variable"
            TYPE_HUMAN="Variable"
            ;;
        "-i")
            debugecho "We have an integer"
            TYPE_HUMAN="Integer"
            ;;
        "-a")
            debugecho "We have an indexed array"
            TYPE_HUMAN="Indexed Array"
            ;;
        "-A")
            debugecho "We have an associative array"
            TYPE_HUMAN="Associative Array"
            ;;
        *)
            echo "Unknown Type! ${TYPE} :-("
            return 57
            echo " YOU SHOULD NEVER SEE THIS!"
            ;;
        esac
    elif DECLARE_OUTPUT=("`declare -f ${VARIABLE_NAME} 2>/dev/null`")
    then
        debugecho "This variable is a function!"
        FUNCTIONboolean="true"
        TYPE="-f"
        TYPE_HUMAN="Function"
    else
        debugecho "Variable does not exist!  :-("
        return 50
    fi
    if [ -z "${EXPORTboolean}" ]
    then
        EXPORTboolean="false"
    fi
    if [ -z "${READONLYboolean}" ]
    then
        READONLYboolean="false"
    fi
    if [ -z "${FUNCTIONboolean}" ]
    then
        FUNCTIONboolean="false"
    fi
    if [ "${TYPE}" == "-a" -o "${TYPE}" == "-A" ]
    then
        # We have an array of sorts, lets strip off the 's for varable consumption
        DECLARE_OUTPUT="`echo ${DECLARE_OUTPUT#\'}`"
        DECLARE_OUTPUT="`echo ${DECLARE_OUTPUT%\'}`"
    fi
    case "${OUTPUT_MODE}" in
    "value")
        echo "${DECLARE_OUTPUT}"
        ;;
    "type")
        echo "${TYPE}"
        ;;
    "human")
        echo "${TYPE_HUMAN}"
        ;;
    "export")
        echo "${EXPORTboolean}"
        ;;
    "readonly")
        echo "${READONLYboolean}"
        ;;
    "function")
        echo "${FUNCTIONboolean}"
        ;;
    "columns")
        echo
        echo -e "[TYPE FLAG]\t[TYPE HUMAN]\t[SET TO EXPORT]\t[SET READ ONLY]\t[FUNCTION?]"
        ;;
    "list")
        if [ "${TYPE}" == "-a" ]
        then
            declare -a DECLARE_OUTPUT_TO_LIST=${DECLARE_OUTPUT}
        elif [ "${TYPE}" == "-A" ]
        then
            declare -A DECLARE_OUTPUT_TO_LIST=${DECLARE_OUTPUT}
        fi
        for ITEM_TO_LIST_INDEX in ${!DECLARE_OUTPUT_TO_LIST[*]}
        do
            list_item "${DECLARE_OUTPUT_TO_LIST[`echo ${ITEM_TO_LIST_INDEX}`]}"
        done
        ;;
    "detail")
        echo -e "${TYPE}\t\"${TYPE_HUMAN}\"\t${EXPORTboolean}\t${READONLYboolean}\t${FUNCTIONboolean}\t${VARIABLE_NAME}"
        ;;
    "")
        DECLARE_OUTPUT="`string_indent_not_first_line DECLARE_OUTPUT '                        '`"
        echo
        echo -e " Variable name:\t\t${VARIABLE_NAME}"
        echo -e " Variable type:\t\t${TYPE_HUMAN} (${TYPE})"
        echo -e " Set to export?:\t${EXPORTboolean}"
        echo -e " Set to readonly?:\t${READONLYboolean}"
        echo -e " Is a function?:\t${FUNCTIONboolean}"
        echo -e " Variable value:\t${DECLARE_OUTPUT}"
        echo
        ;;
    *)
        echo " ERROR!: Unhandled Output Mode: ${OUTPUT_MODE}"
        return 25
        ;;
    esac
    return 0
}

string_indent_not_first_line() 
{
    # ARG1: The name of the multi-line variable that you wish to display with an indent
    # ARG2: The indent text that you want to display in front of every line apart from the first
    test_number_args 2 "$@"			|| return $?
    local VARIABLE="${1}"
    local INDENT_SET="${2}"
    local INDENT
    local LINE
    oIFS="${IFS}"
    IFS="\e"
    eval echo "\"\${${VARIABLE}}\"" | while read "LINE"
    do
        echo "${INDENT}${LINE}"
        if [ -z "${INDENT}" ]
        then
            INDENT="${INDENT_SET}"
        fi
    done
    IFS="${oIFS}"
}

test_arg_exists() 
{
    # ARG1: Argument search regex
    # ARG@: Args To Test
    local SEARCH="${1}"
    shift
    while [ "${#}" -gt "0" ]
    do
        if [[ "${1}" =~ ${SEARCH} ]]
        then
            return 0
        fi
        shift
    done
    return 1
}
