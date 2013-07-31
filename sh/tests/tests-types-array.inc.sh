test_is_array() 
{
    local ARRAY_NAME="${1}"
    local EXIT_STATE=""
    local DECLARE_OUTPUT
    DECLARE_OUTPUT="`declare -p ${ARRAY_NAME} 2>/dev/null`"
    EXIT_STATE="${?}"
    DECLARE_OUTPUT="${DECLARE_OUTPUT#'declare '}"       # Lets strp off the word 'decalre ' with trailing space
    local TYPE="${DECLARE_OUTPUT:0:2}"
    if [ "${EXIT_STATE}" -eq "0" ]
    then
        # We have a variable, lets test if is is an array
        case "${TYPE}" in
        "-a")
            debugecho "We have an array"
            return 0
            ;;
        *)
            debugecho "Not an array I am afraid :-("
            return 55
            ;;
        esac
        echo " YOU SHOULD NEVER SEE THIS!"
    else
        debugecho " Variable does not exist!  :-("
        return 50
    fi
    echo " YOU SHOULD NEVER SEE THIS!"
}

