#!/bin/sh
# Bonus debug script
# This is designed to be . included.  for e.g. in your script do something like:
#  . ${SCRIPT_ROOT}/lib/debug.inc.sh       (or)

# Debug Messages, Set DEBUG=TRUE if you want these to execute at run time
debugecho () {
  MESSAGE="$*"
  if [ "${DEBUG}" = "true" ]
  then
    echo " DEBUG: ${MESSAGE}"
  fi
}

# Debug commands and tests, Set DEBUG=TRUE if you want these commands to execute at run time
debugrun () {
  COMMAND=$1 ; shift
  MESSAGE="$*"
  if [ "${DEBUG}" = "true" ]
  then
    echo
    echo " DEBUGRUN(${COMMAND}): ${MESSAGE}"
    ${COMMAND}
  fi
}

debugtest() {
  #  Use this wherever you rely on the DEBUG var to ensure that it is set
  if [ -z "${DEBUG}" ]
  then
    echo " DEBUG: State not set, defaulting to 'true'"
    export DEBUG=true
  fi
}
