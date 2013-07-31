# This is an include script for including top level functions.
# i.e. functions that are used by other functions and therefore it has to be
# guaranteed that they will be available to any of the automatically included functions

datestamp () {
  date +"%Y-%m-%d[%H-%M-%S]"
  return 0
}

datestamp_new () {
  export DATESTAMP=`datestamp`
  return 0
}

datestamp_append () {
  if [ -z "${DATESTAMP}" ]
  then
    datestamp_new
    echo "No DATESTAMP found, generated ${DATESTAMP}"
  else
    echo "Found DATESTAMP for process. Using ${DATESTAMP}"
    export DATESTAMP
  fi
  return 0
}
get_random_identifier() {
  # 1st form: No Args; Returns a string with a random seed
  # 2st form: ARG1=TAG; Returns a string with a random seed and your ARG1 TAG in the middle
  test_number_args "0|1" $@                 || return $?
  if [ "$#" -eq "0" ]
  then
    # Called with no args, so returning a standard identifier
    echo "SHELL_LIB_$$.${RANDOM}"
    return 0
  else
    # Called with 1 arg, so we will use that in the identifier
    echo "SHELL_LIB_${1}_$$.${RANDOM}"
    return 0
  fi
  echo " WARNING! - You should NEVER see this if this function is working as intended.  If you do, have a look at the code as something is not working!"
}

get_temporary_file() {
  # This function has the following forms:
  # 1st form: No Args; Returns a temporary file handle that has not been and is not in use.
  # 2nd form: ARG1=TAG; Returns a temporary file handle that has not been and is not in use with your ARG1 TAG in the middle.
  test_number_args "0|1" $@                 || return $?
  if [ "$#" -eq "0" ]
  then
    local TEMP_FILE="/tmp/`get_random_identifier`"
    while [ -e /tmp/${TEMP_FILE} ]
    do
      TEMP_FILE="/tmp/`get_random_identifier`"
    done
  else
    local TEMP_FILE="/tmp/`get_random_identifier ${1}`"
    while [ -e /tmp/${TEMP_FILE} ]
    do
      TEMP_FILE="/tmp/`get_random_identifier ${1}`"
    done
  fi
  echo "${TEMP_FILE}"
  return 0
  echo " WARNING! - You should NEVER see this if this function is working as intended.  If you do, have a look at the code as something is not working!"
}

echo_verbose()
{
    # This function takes ARG1 as a message to echo if any of the following args contain a -v verbose flag
    local MESSAGE="${1}"
    shift
    if (test_arg_matches '^(-v|-vv)$' "${1}")
    then
        echo "${MESSAGE}"
    fi
}

echo_super_verbose()
{
    # This function takes ARG1 as a message to echo if any of the following args contain a -v verbose flag
    local MESSAGE="${1}"
    shift
    if (test_arg_exists "-vv" "$@")
    then
        echo "${MESSAGE}"
    fi
}

test_environment()
{
    if [ -z "${SHELL_LIB_HOME}" ]
    then
        echo " \${SHELL_LIB_HOME} is not set... Exiting..."
        exit 99
    elif [ -z "${BASH_VERSION}" ]
    then
        echo " \${BASH_VERSION} is not set...  Asuming we are not in bash, defo not v3 and above..."
    fi
    local BASH_MAJOR_VERSION="`echo ${BASH_VERSION} | awk -F. '{print $1}'`"
    if [ "${BASH_MAJOR_VERSION}" -ge "3" ]
    then
        echo " Using BASH version: ${BASH_VERSION} which is OK as it is above v3"
        return 0
    fi
    exit 1
}

echo()
{
    
    # For portability, some systems do not interpret the flags correctly
    if [ "${1}" = "-e" ]
    then
        shift
        local DISPLAY_TEXT="$@"
        printf "%b\n" "${DISPLAY_TEXT}"     # behaves like 'echo "$var"', except escapes will always be interpreted
    elif [ "${1}" = "-ne" -o "${1}" = "-en" ]
    then
        shift
        local DISPLAY_TEXT="$@"
        printf "%b" "${DISPLAY_TEXT}"     # behaves like 'echo "$var"', except escapes will always be interpreted
    elif [ "${1}" = "-n" ]
    then
        shift
        local DISPLAY_TEXT="$@"
        printf "%s" "${DISPLAY_TEXT}"     # behaves like 'echo "$var"', except escapes will never be interpreted
    else
        local DISPLAY_TEXT="$@"
        printf "%s\n" "${DISPLAY_TEXT}"     # behaves like 'echo "$var"', except escapes will never be interpreted
    fi
}
