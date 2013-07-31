test_number_args() {
  # To verify that a given function or script is handed the correct amount of args,
  # call this function with the first arg being the number of args expected and followed by $@, e.g.
  #   > test_number_args 2 $@       # would test that the calling script was executed with 2 args
  # More complex tests can be performed with regex so, for e.g. you could test with:
  #   > test_number_args '2|3|[5-6]'  # which would allow 2, 3, 5, 6 & 7 args.
  local SPEC="${1}"
  shift
  if (echo $# | eval egrep \'${SPEC}\')>/dev/null 2>&1
  then
    # We tested the spec on the number of args and it passed
    return 0
  else
    # We tested the spec on the number of args and it FAILED!
    echo " Function or Script called with $# arguments and it expected: \"${SPEC}\""
    echo
    return 123
  fi
  echo " WARNING! - You should NEVER see this if this function is working as intended.  If you do, have a look at the code as something is not working!"
}

test_number_args2() {
#set -x
  local -a NUMBER_ARGS_TO_TEST=`text_splitter , ${1}`
  shift
  local -i INDEX
  local TEST_CASE=""
#echo "Index${!NUMBER_ARGS_TO_TEST[@]}"
#echo "Args${NUMBER_ARGS_TO_TEST[@]}"
  for INDEX in ${!NUMBER_ARGS_TO_TEST[@]}
  do
    TEST_CASE="${TEST_CASE}[ $# -eq ${NUMBER_ARGS_TO_TEST[${INDEX}]} ] || "
  done
  TEST_CASE="${TEST_CASE/% || /}"
#echo debug1
  #if (( ${TEST_CASE} ))
  #if [ ${TEST_CASE} ]
  if ( `eval echo ${TEST_CASE}` )
  then
    debugecho " SUCCESS: Function or Script called with $# arguments, expected ${NUMBER_ARGS_TO_TEST}"
  echo "${TEST_CASE}"
    return 0
  else
    echo " Function or Script called with $# arguments, expected ${NUMBER_ARGS_TO_TEST}"
  echo "${TEST_CASE}"
    return 123
  fi
  echo " If this function is working as intended, you will NEVER see this message.  If you do, have a look at the code as something is not working!"
#set +x
}
