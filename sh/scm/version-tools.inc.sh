version_convert_array() {
  # ARG1 is the version you want to convert to an array, this will be returned as an array for consumption by other functions
  # ARG2 is the separator used to separate version components
  local VERSION="${1}"
  local SEPARATOR="${2}"
  local TMP_IFS="${IFS}"
  local IFS="${SEPARATOR}"
  local VERSION_ARRAY_ID=0
  local VERSION_ARRAY=()
  for VERSION_COMPONENT in ${VERSION}
  do
    VERSION_ARRAY[${VERSION_ARRAY_ID}]=${VERSION_COMPONENT}
    VERSION_ARRAY_ID=$((VERSION_ARRAY_ID+1))
  done
  IFS="${TMP_IFS}"
  echo "${VERSION_ARRAY[@]}"
}

version_increment_position() {
  # ARG1 is the version you want to process
  # ARG2 is the separator used to separate version components
  # ARG3 is the position that you want to increment, starting with position 1
  # This version will be returned with the position you referenced of the version incremented by 1
  local VERSION="${1}"
  local SEPARATOR="${2}"
  local POSITION="${3}"
  POSITION=$((POSITION-1))	# Subtract 1 from position so that we can specify pos 1 as array component 0
  VERSION=( `version_convert_array ${VERSION} ${SEPARATOR}` )
  VERSION[${POSITION}]=$((VERSION[${POSITION}]+1))
  text_joiner ${SEPARATOR} ${VERSION[@]}
}

version_increment_major() {
  # ARG1 is the version you want to process
  # This version will be returned with the MAJOR component incremented
  # This function defaults to using a '.' as a separator
  local VERSION="${1}"
  local SEPARATOR="."
  local POSITION="1"
  version_increment_position "${VERSION}" "${SEPARATOR}" "${POSITION}"
}

version_increment_minor() {
  # ARG1 is the version you want to process
  # This version will be returned with the MAJOR component incremented
  # This function defaults to using a '.' as a separator
  local VERSION="${1}"
  local SEPARATOR="."
  local POSITION="2"
  version_increment_position "${VERSION}" "${SEPARATOR}" "${POSITION}"
}

version_increment_micro() {
  # ARG1 is the version you want to process
  # This version will be returned with the MAJOR component incremented
  # This function defaults to using a '.' as a separator
  local VERSION="${1}"
  local SEPARATOR="."
  local POSITION="3"
  version_increment_position "${VERSION}" "${SEPARATOR}" "${POSITION}"
}

version_increment_pico() {
  # ARG1 is the version you want to process
  # This version will be returned with the MAJOR component incremented
  # This function defaults to using a '.' as a separator
  local VERSION="${1}"
  local SEPARATOR="."
  local POSITION="4"
  version_increment_position "${VERSION}" "${SEPARATOR}" "${POSITION}"
}

version_reset_components() {
  # ARG1 is the version you want to process
  # ARG2 is the symbol used as a separator
  # ARG3 is the position to reset version components on, and after
  # ARG4 is the value to reset the version components to
  # This function will return a version with all version components at the position in ARG3 set to the value set in ARG4
  local VERSION="${1}"
  local SEPARATOR="${2}"
  local POSITION="${3}"
  local RESET_CHAR="${4}"
  POSITION=$((POSITION-1))	# Subtract 1 from position so that we can specify pos 1 as array component 0
  VERSION=( `version_convert_array ${VERSION} ${SEPARATOR}` )	# Convers VERSION to an array
  while [ "${POSITION}" -lt "${#VERSION[@]}" ]		# Lets start resetting the VERSION array at POSITION
  do							# with RESET_CHAR, whilst incrementing POSITION
    VERSION[${POSITION}]="${RESET_CHAR}"		# until we have done it for all remaining version
    POSITION=$((POSITION+1))				# components.
  done
  text_joiner ${SEPARATOR} ${VERSION[@]}
}

version_release_major() {
  # ARG1 is the version you want to process
  # This version will be returned with the MAJOR component incremented
  # This function defaults to using a '.' as a separator
  local VERSION="${1}"
  local SEPARATOR="."
  local POSITION="1"
  local RESET_CHAR="0"
  VERSION=`version_increment_position "${VERSION}" "${SEPARATOR}" "${POSITION}"`	# Lets first increment as necessary
  POSITION=$((POSITION+1))	# Add 1 to the position so that we can reset all components after this point
  version_reset_components "${VERSION}" "${SEPARATOR}" "${POSITION}" "${RESET_CHAR}"
}

version_release_minor() {
  # ARG1 is the version you want to process
  # This version will be returned with the MINOR component incremented
  # This function defaults to using a '.' as a separator
  local VERSION="${1}"
  local SEPARATOR="."
  local POSITION="2"
  local RESET_CHAR="0"
  VERSION=`version_increment_position "${VERSION}" "${SEPARATOR}" "${POSITION}"`	# Lets first increment as necessary
  POSITION=$((POSITION+1))	# Add 1 to the position so that we can reset all components after this point
  version_reset_components "${VERSION}" "${SEPARATOR}" "${POSITION}" "${RESET_CHAR}"
}

version_release_micro() {
  # ARG1 is the version you want to process
  # This version will be returned with the MICRO component incremented
  # This function defaults to using a '.' as a separator
  local VERSION="${1}"
  local SEPARATOR="."
  local POSITION="3"
  local RESET_CHAR="0"
  VERSION=`version_increment_position "${VERSION}" "${SEPARATOR}" "${POSITION}"`	# Lets first increment as necessary
  POSITION=$((POSITION+1))	# Add 1 to the position so that we can reset all components after this point
  version_reset_components "${VERSION}" "${SEPARATOR}" "${POSITION}" "${RESET_CHAR}"
}

version_release_pico() {
  # ARG1 is the version you want to process
  # This version will be returned with the PICO component incremented
  # This function defaults to using a '.' as a separator
  local VERSION="${1}"
  local SEPARATOR="."
  local POSITION="4"
  local RESET_CHAR="0"
  VERSION=`version_increment_position "${VERSION}" "${SEPARATOR}" "${POSITION}"`	# Lets first increment as necessary
  POSITION=$((POSITION+1))	# Add 1 to the position so that we can reset all components after this point
  version_reset_components "${VERSION}" "${SEPARATOR}" "${POSITION}" "${RESET_CHAR}"
}



