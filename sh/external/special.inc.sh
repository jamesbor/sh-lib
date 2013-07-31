executor() {
  # ARG1 is the identifier that matches the name of this run
  # differnet names should be used for runs that are expected to be vastly diferent
  local NAME_OF_RUN="${1}"
  shift
  local TEMP_FILE="`get_temporary_file ${NAME_OF_RUN}`"
  $@ | tee ${TEMP_FILE}
  echo ${TEMP_FILE}
}

check_runthing() {
  env_ensure_SHELL_LIB_SETTINGS			|| return $?
  if (test_directory_exists "${SHELL_LIB_SETTINGS}/${1}")
  then
    # We have a runthing, all is good
    return 0
  fi
  return 222  
}

get_runthing() {
  RUN_THING="${1}"
  env_ensure_SHELL_LIB_SETTINGS			|| return $?
  local DATESTAMP=`new_datestamp`
  ensure_directory_exists "${SHELL_LIB_SETTINGS}/${RUN_THING}/${DATESTAMP}"
  echo "${SHELL_LIB_SETTINGS}/${RUN_THING}/${DATESTAMP}"
}

create_runthing() {
  # ARG1: Name of runthing
  echo 
  ensure_directory_exists "${SHELL_LIB_SETTINGS}/${1}"
}

runthing() {
  RUN_THING="${1}"
  shift
  local RUN_THING_INSTANCE=""
  if (check_runthing "${RUN_THING}")
  then
    # We have a runthing
    RUN_THING_INSTANCE=`get_runthing "${RUN_THING}"`
  else
    # We have to create a runthing
    create_runthing "${RUN_THING}"
    RUN_THING_INSTANCE=`get_runthing "${RUN_THING}"`
  fi
  
}

report_function() {
  set | grep '^FUNCNAME='
  set | grep $1
}

test_case() {
  runthing searchLocalFilesystem "find / -name \*.propeties"
}




sender() {

mkfifo filename

echo what you want > filename
}


reader() {

while [ -r filename ]
do
  while read LINE
  do
    echo ${LINE}
  done <filename
done
}
