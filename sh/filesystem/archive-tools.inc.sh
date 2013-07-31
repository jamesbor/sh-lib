archive_location () {
  if [ -z ${ARCHIVE_LOCATION} ]
  then
    ARCHIVE_LOCATION="`pwd`/_ARCHIVE"
    echo " ARCHIVE_LOCATION is not set, setting it to ${ARCHIVE_LOCATION}"
  fi
  if [ ! -d "${ARCHIVE_LOCATION}" ]
  then
    echo " ARCHIVE_LOCATION does not exits, creating it"
    mkdir -v -p ${ARCHIVE_LOCATION}
  fi
}

archive_file () {
  # This is for archiving an individual file to an ARCHIVE_LOCATION
  # If ARCHIVE_LOCATION is set that will be used, otherwise that will be assumed as your current working directory.
  FILE_TO_ARCHIVE="$1"
  archive_location
  mv -n -v ${FILE_TO_ARCHIVE} ${ARCHIVE_LOCATION}/
}

archive_snapshots_file () {
  # This is for archiving the snapshotted files to an ARCHIVE_LOCATION
  # If ARCHIVE_LOCATION is set that will be used, otherwise that will be assumed as your current working directory.
  # As per the archive_file() function.
  FILES_SNAPSHOTS_TO_ARCHIVE="$1"
  FILE_EXTENSION=`file_extension ${FILES_SNAPSHOTS_TO_ARCHIVE}`
  FILE_NAME=`file_name ${FILES_SNAPSHOTS_TO_ARCHIVE}`
  LIST_TO_ARCHIVE="`ls -1 ${FILE_NAME}*${FILE_EXTENSION}`"
  for FILE in ${LIST_TO_ARCHIVE}
  do
    FILE_TEST="`echo ${FILE}| grep -v ${FILE_NAME}.${FILE_EXTENSION}`"
    if [ ! -z "${FILE_TEST}" ]
    then
      archive_file "${FILE_TEST}"
    fi
  done
  #echo $LIST_TO_ARCHIVE | grep -v ${FILE_NAME}.${FILE_EXTENSION}
  #cp -v ${FILE_NAME}*${FILE_EXTENSION} ${ARCHIVE_LOCATION}
  echo
}

archive_snapshots_dir () {
  # This is for archiveing the snapshotted directories to an ARCHIVE_LOCATION
  # If ARCHIVE_LOCATION is set that will be used, otherwise that will be assumed as your current working directory.
  DATESTAMP=`datestamp`
  DIR_TO_ARCHIVE="`strip_trailing_slash $1`"
  archive_location
  mv -v ${DIR_TO_ARCHIVE}.* ${ARCHIVE_LOCATION}/
  echo
}
