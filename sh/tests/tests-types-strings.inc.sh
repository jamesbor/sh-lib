# contains(string, substring)
#
# Returns 0 if the specified string contains the specified substring,
# otherwise returns 1.
test_string_contains() {
  test_number_args 2 $@				|| return $?
  local STRING="${1}"
  local SUB_STRING="${2}"
  if [ "${STRING#*$SUB_STRING}" != "$STRING" ]
  then
    return 0    # $substring is in $string
  else
    return 201    # $substring is not in $string
  fi
}

test_string_delimited_count() {
    test_number_args 3 $@			|| return $?
    local -i COUNT_TO_TEST="${1}"
    local DELIMITER="${2}"
    local STRING_TO_TEST="${3}"
    local -i COUNT="0"
    # Lets start off counting the amount of fields in the STRING_TO_TEST as split by the DELIMITER
    COUNT=`echo ${STRING_TO_TEST} | awk -F${DELIMITER} '{print NF}'`
    # Now lets test if that is what we want?
    if [ "${COUNT}" -eq ${COUNT_TO_TEST} ]
    then
        # We have the amount of components as per COUNT_TO_TEST, as delimited by DELIMITER 
        return 0
    fi
    return 59
}
