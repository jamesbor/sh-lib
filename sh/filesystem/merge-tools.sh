fs_parse_path()
{
    test_number_args 4 "$@"                                     || return $?
    local PATH1="`realpath ${1}`"
    local PATH1_NAME="${2}"
    local PATH2="`realpath ${3}`"
    local PATH2_NAME="${4}"
    
    local PATH_CONTENTS1="`cd ${PATH1} ; find .`"
    #local PATH_CONTENTS2="`cd ${PATH2} ; find .`"
    local MISSING_FILE=""	# Used by the for loop further down
    local REPORT_HEADING="${PATH1_NAME} - Files missing from ${PATH2_NAME}:"
    echo
    echo "${REPORT_HEADING}"
    local REPORT_HEADING_LENGTH="${#REPORT_HEADING}"
    while [ "${REPORT_HEADING_LENGTH}" -gt "0" ]
    do
        echo -n "-"
        REPORT_HEADING_LENGTH=$((REPORT_HEADING_LENGTH - 1))
    done
echo
    for MISSING_FILE in ${PATH_CONTENTS1}
    do
        PATH_PARENT="`dirname ${MISSING_FILE}`"
        PATH_NODE="`basename ${MISSING_FILE}`"
        if [ -e "${PATH_PARENT}/.ignore" ]
        then
            # We have a .ignore file, lets process it
            if ! (grep "${PATH_NODE}" "${PATH_PARENT}.ignore")>/dev/null
            then
                # ITs an ignored file
                #echo ${MISSING_FILE}
                if ( ! test_file_exists "${PATH2}/${MISSING_FILE}" )
                then
                    echo " The file: ${MISSING_FILE} is missing from ${PATH2}"
#        else
             # The file is there too!  Here we can get into diffing! :-)
 #           echo " The file: ${MISSING_FILE} is missing from ${PATH2}"
  #          echo "boo $"
                 fi
             fi
         else
            # ITs an ignored file
            #echo ${MISSING_FILE}
            if ( ! test_file_exists "${PATH2}/${MISSING_FILE}" )
            then
                echo " The file: ${MISSING_FILE} is missing from ${PATH2}"
            fi
        fi
    done
}

fs_merge_report() 
{
    test_number_args 2 "$@"                                     || return $?
    local PATH1="`realpath ${1}`"
    local PATH2="`realpath ${2}`"
    if ( ! test_directory_good_for_read ${PATH1})
    then
        echo " Source Path: ${PATH1} is not readable"
    elif ( ! test_directory_good_for_read ${PATH2})
    then
        echo " Destination Path: ${PATH2} is not readable"
    elif ( ! test_directory_good_for_write ${PATH1})
    then
        echo " Source Path: ${PATH1} is not writeable"
    elif ( ! test_directory_good_for_write ${PATH})
    then
        echo " Destination Path: ${PATH2} is not writeable"
    fi

    fs_parse_path "${PATH1}" "Path 1 (source)" "${PATH2}" "Path 2 (target}"
    fs_parse_path "${PATH2}" "Path 2 (target)" "${PATH1}" "Path 1 (source}"
}
