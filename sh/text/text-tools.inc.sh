text_escape_forwardslash()
{
    test_number_args "1" "$@"                   || return $?
    echo "${1}" | sed 's#\/#\\\/#g'
}

text_joiner() {
  # This function takes ARG1 as a join char abd then returns the rest of the arguments joined by this character
  # e.g. text_joiner - hello there 1 2 3 would return 'hello-there-1-2-3'
  JOIN_CHR="${1}"
  shift
  while [ "${#}" -gt "1" ]
  do
    echo -n "${1}${JOIN_CHR}"
    shift
  done
  echo "${1}"
}

text_splitter() {
  # This function takes ARG1 as a split char and then returns the rest of the arguments, split by that char ready for consumption into an array
  # e.g. if called as:  $  text_splitter , blahh,blahhblahh,bllll ahhhhh        ...then it would return:
  #   '([0]="blahh" [1]="blahhblahh" [2]="bllll ahhhhh")'
  # So, if you want to set a variable to use it, you would do something like:
  # local -a SOME_ARRAY=`text_splitter , blahh,blahhblahh,bllll ahhhhh`  which would be the equivalent to typing:
  # local -a SOME_ARRAY='([0]="blahh" [1]="blahhblahh" [2]="bllll ahhhhh")'       
  # DO NOT FORGET THE -a on the declaration, use declare -a if not local
  # BUT DO NOT FORGET THIS!!  The shell will not understand that it is an array and bad things will happen! :-(
  local SPLIT_CHR="${1}"
  shift
  local -a SPLIT_DATA=()
  IFS="${SPLIT_CHR}" read -ra SPLIT_DATA <<< "${@}"
  set | grep '^SPLIT_DATA=' | sed 's/^SPLIT_DATA=//'	# Lets output it as all you would need to assign the values to an array varaible
  return 0
}

filter_empty_lines() {
  echo ${1} | grep -v "^$"
}

textFilterStringErase()
{
    local STRING_TO_REMOVE="${1}"
    shift
    local STRING_TO_PARSE="${@}"
    echo "${STRING_TO_PARSE}" | eval sed \"s/${STRING_TO_REMOVE}//g\"
}

textFilterStringReplace()
{
    local STRING_TO_SEARCH="${1}"
    shift
    local STRING_TO_REPLACE="${1}"
    shift
    local STRING_TO_PARSE="${@}"
    echo "${STRING_TO_PARSE}" | eval sed \"s/${STRING_TO_SEARCH}/${STRING_TO_REPLACE}/g\"
}

textFilterStringSplit()
{
    local DELIMITER="${1}"
    shift
    #local -a SPLIT_TEXT=()
    #SPLIT_TEXT="`text_splitter "${DELIMITER}" "$@"`"
    local -a SPLIT_TEXT="`text_splitter "${DELIMITER}" "$@"`"
    echo "${SPLIT_TEXT[@]}"
}

chomp() {
  if [ $# -gt 0 ]
  then
    echo -n $@
  else
    while read LINE
    do
      echo -n "${LINE}"
    done
  fi
}
