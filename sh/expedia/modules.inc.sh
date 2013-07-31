universal_function_wrapper() {
  # Universal function handler, ARG1 is function to call and pass rest of args as STDIN
  if [ $# -gt 1 ]
  then
    FUNC_TO_CALL="${1}"
    shift
    ${FUNC_TO_CALL} "${@}"
  else
    while read LINE
    do
      FUNC_TO_CALL="echo ${LINE} | cut -d' ' -f1"
      shift
      ${FUNC_TO_CALL} "${@}"
    done
  fi
}

list_modules () {
  # List all the hcom.modules
  list_http_children_dirs ${REPO_URL_HCOM_MODULES}
}

list_module_versions () {
  # List all the versions for an hcom.module
  MODULE_TO_LIST=${1}
  list_http_children_dirs ${REPO_URL_HCOM_MODULES}/${MODULE_TO_LIST}
}

list_modules_find_jumps() {
  # This function is for iterating through all the modules and finding the ones that have jumped more than
  # JUMP_COUNT is set to
  JUMP_COUNT=2
  FOUND_JUMP=0
  for MODULE in `list_modules`
  do
    #echo "Processing: ${MODULE}"
    VERSIONS=`list_module_versions ${MODULE} | sort -g`
    MODULE_VERSION_JUMP_COUNT=${JUMP_COUNT}
    for VERSION in ${VERSIONS}
    do
      MAJOR_VERSION=`echo ${VERSION} | cut -d. -f1`
      MINOR_VERSION=`echo ${VERSION} | cut -d. -f2`
      #echo "Major: ${MAJOR_VERSION}, Minor: ${MINOR_VERSION}"
      if [ -z "${PREV_MAJOR_VERSION}" ]
      then
        PREV_MAJOR_VERSION=0
        #echo "Setting PREV_MAJOR_VERSION to 0"
      #else
       # echo "Is set to ${PREV_MAJOR_VERSION}"
      fi
      if [ "`expr ${MAJOR_VERSION} - ${PREV_MAJOR_VERSION}`" -gt ${JUMP_COUNT} ]
      then
        if [ "${FOUND_JUMP}" -eq "0" ]
        then
          echo -n "Module: ${MODULE} jumped from ${PREV_MAJOR_VERSION} to ${MAJOR_VERSION}"
        elif [ "${FOUND_JUMP}" -gt "0" ]
        then
          echo -n ", and jumped from ${PREV_MAJOR_VERSION} to ${MAJOR_VERSION}"
        fi
        FOUND_JUMP="`expr ${FOUND_JUMP} + 1`"
      fi
      PREV_MAJOR_VERSION=${MAJOR_VERSION}
    done
    if [ "${FOUND_JUMP}" -gt "0" ]
    then
      echo ", Latest version is: ${VERSION}"
      FOUND_JUMP=0
    fi
    unset PREV_MAJOR_VERSION
  done
}
