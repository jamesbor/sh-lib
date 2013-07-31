#!/bin/bash

# This is the master include script for the library

## Configurable Options:
## Ordered list of functions to manually include in the shell library. 
## Whitespace seperate to provide more than one within the speach marks:
MANUALLY_ADDED_FUNCTIONS="	display/display-core.inc.sh 
				top_level_functions.inc.sh"
# lets set up some values:
SUPER_PATH=${PWD}
SUPER_PATHLET=`echo ${BASH_SOURCE}	| # Get the name of this file from the array varable BASH_SOURCE
		sed 's/^\.\///g'	` # The include might have been prefixed with ./, if so, lets strip off the dot slash
# Lets test if the path is relative or absolute
if (echo "${SUPER_PATHLET}" | grep '^/')
then
    # We are called with an absolute path
    SHELL_LIB_HOME="`dirname ${SUPER_PATHLET}`"			# Derive the SHELL_LIB_HOME
else
    # We are called with a relative path
    SHELL_LIB_HOME="`dirname ${SUPER_PATH}/${SUPER_PATHLET}`"	# Derive the SHELL_LIB_HOME
fi
REPORT_PREFIX=""						# Used when reporting things later on for conditional elements that need to add things to the output

# Lets start with a empty line:
echo

# Now lets have any functions we use:
test_number_args() 
{
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
        return 123
    fi
    echo " WARNING! - You should NEVER see this if this function is working as intended.  If you do, have a look at the code as something is not working!"
}

test_if_i_am_sourced()
{
    test_number_args 1 "$@"				|| return $?
    if [ "${FUNCNAME[1]}" = source ]
    then
        if [ "$1" = -v ]
        then
            echo "Sourcing: ${BASH_SOURCE[0]} from caller script/shell: $0"
        fi
        return 0
    else
    if [ "$1" = -v ]
    then
        echo "I am not being sourced, my script/shell name was $0"
    fi
    return 1
  fi
}

realpath() 
{
    test_number_args 1 "$@"				|| return $?
    local PATH_TO_NORMALISE="${1}"
    if [ "${PATH_TO_NORMALISE}" == "." ]
    then
        NORMALISED_PATH="`pwd`"
    else
        NORMALISED_PATH="`cd ${PATH_TO_NORMALISE} ; pwd`"
    fi
    if [ "$?" -eq "0" ]
    then
        echo "${NORMALISED_PATH}"
        return 0
    else
        return 125
    fi
}

# Now we have some functions, lets normalise our path
SHELL_LIB_HOME="`realpath ${SHELL_LIB_HOME}`"

# Lets chcek if we are sorced and bomb out if not
if ! (test_if_i_am_sourced -v)
then
    echo " This script is designed to be sourced or . included only" 
    echo " Please use this script by executing either:"
    echo 
    echo "  #  source ${SUPER_PATHLET}         (or)"
    echo "  #  . ${SUPER_PATHLET}"
    echo 
    echo " This will include the script and its functions into the shell that you are currently opperating."
    echo " If you are seeing this and you have done the above then check that the calling shell is catered for"
    echo " in the case statement in ${SUPER_PATHLET}"
    echo 
    exit 100
fi
echo " Master Shell Library Included In Shell"
echo " SHELL_LIB_HOME is ${SHELL_LIB_HOME}"

# Lets define any other functions that are internal to this script:
source_file() {
  local FILE_TO_SOURCE="${1}"
  local FILE_TYPE=`echo ${FILE_TO_SOURCE} | awk -F\. '{print $NF}'`	# Lets get the file extension so we know what we are doing
  local LINE=""
  local PARSE_COUNT="0"
  local ERROR_COUNT="0"
  local ARRAY_COUNT="0"
  local PROPERTY_TYPE=""
  case "${FILE_TYPE}" in
  properties)
    PROPERTY_TYPE="`echo "${FILE_TO_SOURCE}" | awk -F. '{print $(NF-1) }'`"
    case "${PROPERTY_TYPE}" in
    "values")
      PROPERTY_NAME="`echo "${FILE_TO_SOURCE}" | awk -F. '{print $1 }' | xargs basename`"
      eval ${PROPERTY_NAME}="()"						 	  # Lets empty the varable array in case it already exists
      list_properties "${FILE_TO_SOURCE}" | while read CONTENT_TO_SOURCE
      do
        PARSE_COUNT=$((PARSE_COUNT + 1))
        export "${CONTENT_TO_SOURCE}"
        ERROR_COUNT=$((ERROR_COUNT+$?))
      F1_WIDTH=35
      F2_WIDTH=35
        REPORT_ITEM="`echo ${CONTENT_TO_SOURCE} | sed 's///g'`"
        echo "${REPORT_ITEM}=${PARSE_COUNT}"						| # Lets have the data needed for the reported output
          #awk -F= '{ printf ( "%35s=%-.35s=%3s\n",$1 ,$2, $3) }' 			| # Okay, lets do some formating, on first pass we need to cut the 2'nd field to its max width
          #awk -F= '{ printf ( "%35s exported as %-35s [%3s]\n", $1, $2, $3) }'		  # and on the second pass we can finish presenting for display
          awk -F= '{ fmt = sprintf("%%%ds=%%-.%ds=%%3s\n", COL1, (COL2 - COL1 - 6 - 13)); printf fmt, $1, $2, $3; }' COL1=35 COL2=${COLUMNS}  |
          awk -F= '{ fmt = sprintf("%%%ds exported as %%-%ds [%%3s]\n", COL1, (COL2 - COL1 - 6 - 13)); printf fmt, $1, $2, $3; }' COL1=35 COL2=${COLUMNS}
      done
      REPORT_PREFIX="${PARSE_COUNT} properties exported for use in shell from: "
      ;;
    esac
    return ${ERROR_COUNT}
    ;;
  sh)
    source ${FILE_TO_SOURCE} 2>/dev/null
    return $?
    ;;
  *)
    echo "ERROR! UNKNOWN FILETYPE"
    ;;
  esac
}

list_values() {
  local FILE_TO_SOURCE="${1}"
  cat ${FILE_TO_SOURCE}		| # Grab the contents of the file specified.
    awk -F\# '{ print $1 }'	| # Strip the lines starting at # for comments, trailing. and leading whitespace
    awk '{ print $0 }'		| # Strip off any remaining whitespace
    grep -v '^#'		| # Grep to strip the lines that start as comments
    grep -v '^[ \t]*$'		  # Grep remove the lines containing nothing but whitespace
}

list_properties() {
  local FILE_TO_SOURCE="${1}"
  cat ${FILE_TO_SOURCE}		| # Grab the contents of the file specified.
    grep '='			| # Grep for just the lines that have '=' and therefore properties on them
    awk -F\# '{ print $1 }'	| # Strip the lines starting at # for comments, trailing. and leading whitespace
    awk '{ print $0 }'		| # Strip off any remaining whitespace
    grep -v '^#'		  # Grep to strip the lines that start as comments
}

list_functions() {
  local FILE_TO_REPORT="${1}"
  cat ${FILE_TO_REPORT}		| # Grab the contents of the file just sourced into the env.
    grep '()'			| # Grep for just the lines that have function definitions on them
    awk -F\( '{ print $1 }'	| # Strip the lines starting at ( of the () function dec. and leading whitespace
    awk '{ print $1 }'		| # Strip off any remaining whitespace
    grep -v 'local'		| # Strip off any lines containing the word local as these are local arrays not functions
    grep -v '^#'		  # Grep to strip the lines that start as comments
}

report_functions () {
  # Now lets report the list of functions just included:
  local FILE_TO_REPORT="${1}"
  local INCLUDED_FUNCTION_LIST="`list_functions ${FILE_TO_REPORT}`"
  for SUB_ITEM in ${INCLUDED_FUNCTION_LIST}
  do
    list_sub_item "${SUB_ITEM}()"
  done
}

source_include_files () {
  # This funciton source includes either functions or properties into a shell, with the added reporting state of manual
  local TYPE_OF_RUN="${1}"
  local INCLUDE_FILES=()
  local PATH_PREFIX=""
  local PATH_PREFIX_SOURCE=""
  local REPORT_POSTFIX=""
  local ITEM_TO_PREFIX=""
  case "${TYPE_OF_RUN}" in 
  "manual")
    PATH_PREFIX="${SHELL_LIB_HOME}/sh"
    PATH_PREFIX_SOURCE="${PATH_PREFIX}/"
    REPORT_POSTFIX=" (m)"
    INCLUDE_FILES="${MANUALLY_ADDED_FUNCTIONS}"
    ;;
  "auto")
    PATH_PREFIX="${SHELL_LIB_HOME}/sh"
    MANUALLY_ADDED_FUNCTIONS=`for ITEM_TO_PREFIX in ${MANUALLY_ADDED_FUNCTIONS}
	do
	  echo ${PATH_PREFIX}/${ITEM_TO_PREFIX}
	done`
    AUTO_INCLUDE_FILES="`find ${PATH_PREFIX} -name \*.inc.sh`"
    INCLUDE_FILES=`echo ${AUTO_INCLUDE_FILES} ${MANUALLY_ADDED_FUNCTIONS}	| # Get the list of things to remove dupes from
      	awk ' { for (i = 1; (i <= NF); i++) print $i } '			| # Ensure there is a newline after every item
      	sort									| # sort it all so the next command works
      	uniq -u									`  # remove any items that have duplicates
    ;;
  "property")
    PATH_PREFIX="${SHELL_LIB_HOME}/properties"
    REPORT_POSTFIX=" (p)"
    INCLUDE_FILES="`find ${PATH_PREFIX} -name \*.inc.properties`"
    ;;
  "property-values")
    PATH_PREFIX="${SHELL_LIB_HOME}/properties"
    REPORT_POSTFIX=" (pv)"
    INCLUDE_FILES="`find ${PATH_PREFIX} -name \*.values.properties`"
    ;;
  *)
    echo error
    ;;
  esac
  for INCLUDE_FILE in ${INCLUDE_FILES}
  do
    source_file ${PATH_PREFIX_SOURCE}${INCLUDE_FILE}
    SOURCE_EXIT_LEVEL=$?
    # Now, lets strip off the leading path
    ESCAPED_PATH="`echo ${PATH_PREFIX} | sed 's#\/#\\\/#g'`"
    INCLUDE_FILE_STRIPED=`echo ${INCLUDE_FILE} | sed "s#${ESCAPED_PATH}\/##g"`
    if [ "${SOURCE_EXIT_LEVEL}" = "0" ]
    then
      list_item "Successfully included: ${REPORT_PREFIX}${INCLUDE_FILE_STRIPED}${REPORT_POSTFIX}"
      REPORT_PREFIX=""
      case "${TYPE_OF_RUN}" in 
      "property")
        ;;
      *)
        report_functions ${PATH_PREFIX_SOURCE}${INCLUDE_FILE}
        ;;
      esac
    else
      list_item "There was a problem including: ${INCLUDE_FILE_STRIPED}${REPORT_POSTFIX}"
    fi
  done
}

export SHELL_LIB_HOME
source_include_files manual
list_item "Exporting Properties for use in your (and your childrens) shell(s):"
source_include_files property
list_item "Exporting Properties with multi values for use in your (and your childrens) shell(s):"
source_include_files property-values
source_include_files auto
echo " Included into shell @ `datestamp` from: ${SHELL_LIB_HOME}"
echo
