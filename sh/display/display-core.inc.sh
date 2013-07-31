# This function takes a set of args and will list them all on new lines
# prefixed with ' - ' as bullets, if you want to change the bullet char
# then look at the functions available from the non core include files.
list_items() {
  # This function lists a given set of args, prefixed with ' - '
  for ARG_TO_LIST in $@
  do
    echo "  - ${ARG_TO_LIST}"
  done
}

list_item() {
  # This function is for producing individual list items prefixed with ' - '
  echo "  - $@"
}

# This function takes a set of args and will list them all on new lines
# prefixed with '   - ' as bullets, if you want to change the bullet char
# then look at the functions available from the non core include files.
list_sub_items() {
  # This function lists a given set of args, prefixed with ' - '
  for ARG_TO_LIST in $@
  do
    echo "    - ${ARG_TO_LIST}"
  done
}

list_sub_item() {
  # This function is for producing individual list items prefixed with '   - '
  echo "    - $@"
}

echo_wrap() {
  # This function utilizes the $COLUMNS var available in bash to describe the width of the terminal and wrap text so that it never exceeds this value
echo
}

echo_truncate() {
  # This function utilizes the $COLUMNS var available in bash to describe the width of the terminal
  # and truncate text so that so that it never exceeds this value
  TEXT_TO_TRUNCATE="$@"
  #TEXT_LENGTH=`echo ${TEXT_TO_TRUNCATE} | wc -c`
  #TEXT_LENGTH2=${#TEXT_TO_TRUNCATE}
  if [ "${#TEXT_TO_TRUNCATE}" -le "${COLUMNS}" ]
  then
    echo "${TEXT_TO_TRUNCATE}"
  else
    echo "${TEXT_TO_TRUNCATE:(-$(($COLUMNS-3)))}..."
  fi
}
