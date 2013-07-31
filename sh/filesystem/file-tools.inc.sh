file_extension() {
  # This function takes the first argument given to it; assumably a complete filename, 
  # strips off the extension and returns the extension.
  FILENAME_TO_PARSE="${1}"
  echo ${FILENAME_TO_PARSE} | awk -F\. '{print $NF}'
  # echo ${FILENAME_TO_PARSE} | sed 's/.*\.//g'  # Find any chrs, any times, until an actual '.' and replace it with nothing
}

file_name() {
  # This function takes the first argument given to it; assumably a complete filename,
  # strips off the extension and returns the filename without it.
  FILENAME_TO_PARSE="${1}"
  echo ${FILENAME_TO_PARSE} | sed 's/\(.*\)\..*/\1/' 
}

#strip_trailing_slash() {
#  # Give back ARG1, stripping the last trailing slash
#  echo ${1} |  sed -e 's,/$,,'
#}

#strip_trailing_slash_stdin() {
#  # Strip the trailing slash from whatever is sent to the STD_IN of the function
#  while read DATA_TO_PROCESS
#  do
#    echo ${DATA_TO_PROCESS} |  sed -e 's,/$,,'
#  done
#}

strip_trailing_slash() {
  # Strip trailing slashes, all of them, from whatever is given to ARG1 or STDIN
  if [ $# -gt 0 ]
  then
    dirname "${1}/."
  else
    while read LINE
    do
      dirname "${LINE}/."
    done
  fi
}

ensure_trailing_slash() {
  strip_trailing_slash ${@}	| # strip the trailing slash to baseline any slashes that might be there
	sed 's,$,/,'		  # append a / to the end of whatever was passed from the previous command
	# awk -F/ ' { for (i = 1; (i <= NF); i++) printf "%s/", $i } '	  # append a / to the end of whatever was passed from the previous command
}

add_prefix_slash()
{
    test_number_args "1" "$@"				|| return $?
    echo "$1" | sed -e 's/.*/\/&/'
}

strip_prefix_slash()
{
    test_number_args "1" "$@"				|| return $?
    echo "$1" | sed -e 's,^/,,'
}

ensure_prefix_slash()
{
    test_number_args "1" "$@"				|| return $?
    local STRING_TO_PARSE="${1}"
    while [[ "${STRING_TO_PARSE}" =~ ^\/ ]]
    do
        STRING_TO_PARSE="`strip_prefix_slash ${STRING_TO_PARSE}`"
    done
    echo "${STRING_TO_PARSE}"
}

ensure_absolute_path_old() {
  # This function will return ARG1 as is if it starts with a '/' but if not, it will prefix it with the path of the current working directory
  # At some point I might make it have the option of taking two args if you want to give it the prefix path that should be used instead of PWD
  test_number_args "1" "$@"				|| return $?
  local PATH_TO_NORMALIZE="${1}"
  #echo "${PATH_TO_NORMALIZE}" | grep '^/' 2>&1 /dev/null
  echo "${PATH_TO_NORMALIZE}" | grep '^/' 1>/dev/null 2>/dev/null
#echo $?
  if [ "$?" != "0" ]
  then
    # The PATH_TO_NORMALIZE is not prefixed with a '/' slash.  Assuming it is a relative path from current working directory and prefixing as such.
    env_ensure_PWD
    PATH_TO_NORMALIZE="`echo ${PWD}/${PATH_TO_NORMALIZE}`"
  fi
  echo "${PATH_TO_NORMALIZE}"
  return 0
}

ensure_absolute_path() {
  # This function will return ARG1 as is if it starts with a '/' but if not, it will prefix it with the path of the current working directory
  # At some point I might make it have the option of taking two args if you want to give it the prefix path that should be used instead of PWD
  test_number_args 1 $@                 || return $?
  local PATH_TO_NORMALIZE="${1}"
  if !(echo "${PATH_TO_NORMALIZE}" | grep '^/')>/dev/null
  then
    # The PATH_TO_NORMALIZE is not prefixed with a '/' slash.  Assuming it is a relative path from current working directory and prefixing as such.
    env_ensure_PWD
    PATH_TO_NORMALIZE="`echo ${PWD}/${PATH_TO_NORMALIZE}`"
  fi
  echo "${PATH_TO_NORMALIZE}"
  return 0
}

ensure_directory_exists () {
  # ARG1=DIRECTORY; This is ensured to exist, if it is not there, it will be created with any children
  test_number_args 1 $@			|| return $?
  local DIRECTORY="${1}"
  if [ -d "${DIRECTORY}" ]
  then
    return 0
  else
    if (mkdir -v -p "${DIRECTORY}")
    then
      echo " Successfully created: ${DIRECTORY}"
      return 0
    else
      echo " FAILED to create directory: ${DIRECTORY}"
      return 90
    fi
  fi
}

realpath() 
{
    test_number_args 1 "$@"		|| return $?
    local PATH_TO_NORMALISE="${1}"
    if [ "${PATH_TO_NORMALISE}" == "." ]
    then
        NORMALISED_PATH="`pwd`"
    else
        if (cd "${PATH_TO_NORMALISE}" 2>/dev/null >/dev/null)
        then
            NORMALISED_PATH="`cd ${PATH_TO_NORMALISE} ; pwd`"
            echo "${NORMALISED_PATH}"
            return 0
        else
            # The path does not exist
            return 125
        fi
    fi
}

get_file_modtime_epoch()
{
    test_number_args 1 "$@"		|| return $?
    local FILE_TO_QUERY="${1}"
    stat -r "${FILE_TO_QUERY}" | awk '{print $10}'
}

set_file_datetime()
{
    # This function takes a time/date in the following format:
    # '[[CC]YY]MMDDhhmm[.SS]'
    # and updates a files modified and access times
    test_number_args 2 "$@"		|| return $?
    local FILE_TO_UPDATE="${1}"
    local DATETIME="${2}"
    test_file_good_for_write "${FILE_TO_UPDATE}"
    touch -t "${DATETIME}" "${FILE_TO_UPDATE}"
}

set_file_datetime_epoch()
{
    # This function takes a time/date in the epoch format
    # and updates a files modified and access times
    test_number_args 2 "$@"		|| return $?
    local FILE_TO_UPDATE="${1}"
    local DATETIME="`convert_datetime_epoch_touch ${2}`"
    test_file_good_for_write "${FILE_TO_UPDATE}"
    touch -t "${DATETIME}" "${FILE_TO_UPDATE}"
}

get_files_containing()
{
    test_number_args 2 "$@"		|| return $?
    local STRING_TO_FIND="${1}"
    local PATH_TO_SEARCH="${2}"
    grep -H -R ${STRING_TO_FIND} ${PATH_TO_SEARCH} | awk -F: '{print $1}'
    
}
