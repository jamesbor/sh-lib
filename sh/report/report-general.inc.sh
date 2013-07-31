report_arguments()
{
    # This function is used as follows:
    #  $ report_arguments "$@" to pass the arguments of the calling script to the child function
    # It should return a report of the arguments that were passed to it
    local COUNT_OF_ARGS="$#"
    local COUNT_INSTANCE=1
    echo
    echo " The shell / script: $0,"
    echo " ...that was run in: `pwd`,"
    if [ "$#" -gt "0" ]
    then
        echo " ...was called with: $# arguments.  These are set as follow:"
        for ARG_VALUE in "$@"
        do
            echo " - Arg [${COUNT_INSTANCE}/${COUNT_OF_ARGS}] (${ARG_VALUE})"
            COUNT_INSTANCE=`expr ${COUNT_INSTANCE} + 1`
        done
    else
        echo " ...was called with no arguments."
    fi
}

check_arguments_empty()
{
    # This function is used as follows:
    #  $ check_arguments_empty "$@" to pass the arguments of the calling script to the child function
    # It should return a list of argument possitions for any that are empty
    local COUNT_OF_ARGS="$#"
    local COUNT_INSTANCE=1
    if [ "$#" -gt "0" ]
    then
        for ARG_VALUE in `seq $#`
        do
            if [ -z "`eval echo \\$${ARG_VALUE}`" ]
            then
                echo -n "${ARG_VALUE} "
            fi
            COUNT_INSTANCE=`expr ${COUNT_INSTANCE} + 1`
        done
    fi
}

report_path() 
{
  local PATH_ITEM
  echo
  if [ -z "${PATH}" ]
  then
    # We no not have a PATH
    echo ' The ${PATH} varable is not set'
  else
    # We have a PATH, lets display its contents
    echo ' The ${PATH} varable is setup in the following order:'
    for PATH_ITEM in `echo ${PATH} | tr : '\n'`
    do
      echo " > ${PATH_ITEM}"
    done
  fi
}

report_ldlibrary_path()
{
  local PATH_ITEM
  echo
  if [ -z "${LD_LIBRARY_PATH}" ]
  then
    # We do not have an LD_LIBRARY_PATH
    echo ' The ${LD_LIBRARY_PATH} varable is not set'
  else
    # We have an LD_LIBRARY_PATH set, lets display its contents
    echo ' The ${LD_LIBRARY_PATH} varable is setup in the following order:'
    for PATH_ITEM in `echo ${LD_LIBRARY_PATH} | tr : '\n'`
    do
      echo " > ${PATH_ITEM}"
    done
    echo
  fi
}

report_environment()
{
  local ECHO_KEY
  local ECHO_VALUE
  echo
  echo " The following environment varables are availiable in this shell:"
  env | while read LINE
  do
    ECHO_KEY=`echo ${LINE} | cut -d = -f 1`
    ECHO_VALUE=`echo ${LINE} | cut -d = -f 2`
    echo | awk '{printf "%30s %-s \n", ECHO_KEY, ECHO_VALUE; }' ECHO_KEY="${ECHO_KEY}" ECHO_VALUE="${ECHO_VALUE}"
  done
}
