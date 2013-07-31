get_settings() 
{
    test_number_args "1" "$@"							|| return $?
    env_ensure_SHELL_LIB_SETTINGS						|| return $?
    local SETTING="${1}" ; shift
    #local SETTING_PATH="`dirname ${SETTING}`"
    #local SETTING_NAME="`basename ${SETTING}`"
    if (test_file_good_for_read "${SHELL_LIB_SETTINGS}/${SETTING}.settings")
    then
        cat ${SHELL_LIB_SETTINGS}/${SETTING}.settings
    else
        return 1
    fi
}

set_settings() 
{
    test_number_args "2" "$@"							|| return $?
    env_ensure_SHELL_LIB_SETTINGS						|| return $?
    local SETTING="${1}" ; shift
    local SETTING_PATH="`dirname ${SETTING}`"
    #local SETTING_NAME="`basename ${SETTING}`"
    if ! (test_directory_good_for_write "${SHELL_LIB_SETTINGS}/${SETTING_PATH}")
    then
        mkdir -p "${SHELL_LIB_SETTINGS}/${SETTING_PATH}"			|| return $? # Need to sort this out
    fi
    test_potential_file_good_for_write \
	"${SHELL_LIB_SETTINGS}/${SETTING}.settings"				|| return $?
    echo "$@" | while read -r LINE
    do
        if (test_file_contains_string "${SHELL_LIB_SETTINGS}/${SETTING}.settings" "${LINE}")
        then
            debugecho " We already had: ${LINE}"
        else
            echo "${LINE}" >> "${SHELL_LIB_SETTINGS}/${SETTING}.settings"
        fi
    done
}


read_settings_file()
{
    SETTING_FILE="${1}"
    while read LINE
    do
        echo "${LINE}"
    done <${SETTING_FILE}
}

getSetting()
{
    test_number_args "2" "$@"							|| return $?
    if [ ${#} -eq 2 ]
    then
    local PROPERTY_NAME="${1}"
    local FILE="${2}"
    # These look scary, but they're actually not:
    #        cat ${FILE} 2>/dev/null
    #           Get the contents of the file.  Ignore any error messages
    #           if we cant read it or if it doesnt exist.
    #
    #        sed 's/\r*//'
    #           Strip any spurious carriage returns (i.e. dos2unix)
    #
    #        sed 's/^[ \t]*//'
    #           Strip any leading (^) white space ( [ \t]* ) from each
    #           line
    #
    #        eval grep -w '\^${PROPERTY_NAME}'
    #           Look for lines beginning with ${PROPERTY_NAME}.  The
    #           eval first expands any environment variables, THEN
    #           it passes it to the shell (which may further expand
    #           environment variables) e.g.:
    #
    #               FOO=BAR
    #               BAR=Value of Bar
    #               echo $${FOO}
    #                 -->   55{FOO}
    #                 -->   (you asked it to echo '$$'  (process id)
    #                       followed by {FOO}
    #
    #               eval echo \$${FOO}
    #                 --> Value of Bar
    #                why?
    #                       eval input: echo \$${FOO}
    #                       eval output:    echo $BAR
    #               then
    #                       shell input:    echo $BAR
    #
    #        awk -F= ' { print $2 } '
    #           Use = as the field separator, give me the second field.
    #
    #        sed 's/^[ \t]*//'
    #           Strip any leading whitespace from the value.
    #
        cat ${FILE} 2>/dev/null \
            | sed 's/\r*//' \
            | sed 's/^[ \t]*//' \
            | sed 's/[ \t]*=[ \t]*/=/' \
            | eval grep -w '\^${PROPERTY_NAME}' \
            | awk -F= ' { print $2 } ' \
            | sed 's/^[ \t]*//'
    fi
}
