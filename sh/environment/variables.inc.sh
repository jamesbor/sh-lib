env_ensure_COLUMNS() {
  local STTY_LOCATION=""
  local STTY_COLUMNS=""
  if [ -z ${COLUMNS} ]
  then
    echo "Environment Variable: COLUMNS is not set, setting now!"
    STTY_LOCATION=`which stty`
    if [ $? -ne 0 ]
    then
      echo "Your shell has no COLUMNS variable, and, you have no stty on your path, what kind of shell are you using?? :-)"
      echo "Assuming a default value of - 80"
      export COLUMNS=80
    else
      STTY_COLUMNS=`${STTY_LOCATION} size | awk '{print $2}'`
      echo "The stty executable reports that your terminal has ${STTY_COLUMNS} columns, using this value."
      export COLUMNS=${STTY_COLUMNS}
    fi
  else
    export COLUMNS
  fi
}

env_ensure_LINES() {
  local STTY_LOCATION=""
  local STTY_LINES=""
  if [ -z ${LINES} ]
  then
    echo "Environment Variable: LINES is not set, setting now!"
    STTY_LOCATION=`which stty`
    if [ $? -ne 0 ]
    then
      echo "Your shell has no LINES variable, and, you have no stty on your path, what kind of shell are you using?? :-)"
      echo "Assuming a default value of - 24"
      export LINES=24
    else
      STTY_LINES=`${STTY_LOCATION} size | awk '{print $1}'`
      echo "The stty executable reports that your terminal has ${STTY_LINES} lines, using this value."
      export LINES=${STTY_LINES}
    fi
  else
    export LINES
  fi
}

env_ensure_PWD() {
  local PWD_LOCATION=""
  local PWD_VALUE=""
  if [ -z ${PWD} ]
  then
    echo "Environment Variable: PWD is not set, setting now!"
    PWD_LOCATION=`which pwd`
    if [ $? -ne 0 ]
    then
      echo "Your shell has no PWD variable, and, you have no pwd executable on your path, what kind of shell are you using?? :-)"
      echo "Assuming a default value of /tmp"
      export PWD=/tmp
    else
      PWD_VALUE=`${PWD_LOCATION}`
      echo "The ${PWD_LOCATION} executable reports that your terminal has a working directory of ${PWD_VALUE}, using this value."
      export PWD=${PWD_VALUE}
    fi
  else
    export PWD
  fi
}

env_ensure_SHELL_LIB_SETTINGS() {
  test_number_args 0 $@                 || return $?
  if (testVarableEmpty "SHELL_LIB_SETTINGS")
  then
    if (testVarableEmpty "SHELL_LIB_HOME")
    then
      echo " You need to have SHELL_LIB_HOME set as an evnironment varable,  This should happen when you source include.me"
      exit 1
    else
      SHELL_LIB_SETTINGS="${SHELL_LIB_HOME}/settings"
    fi
  fi
  if ! (test_directory_good_for_read "${SHELL_LIB_SETTINGS}")
  then
    echo " SHELL_LIB_SETTINGS directory does not exist!  Creating..."
    ensure_directory_exists "${SHELL_LIB_SETTINGS}"		|| return $?
    test_directory_good_for_read "${SHELL_LIB_SETTINGS}"	|| return $?
  fi
}
