snapshot_file () {
  # This is for snapshoting a file with a current DATESTAMP
  # DATESTAMP should no longer be unset as part of this function, but I have not tested this yet.
  DATESTAMP=`datestamp`
  FILE_TO_ARCHIVE="$1"
  FILE_EXTENSION=`file_extension ${FILE_TO_ARCHIVE}`
  FILE_NAME=`file_name ${FILE_TO_ARCHIVE}`
  cp -v ${FILE_TO_ARCHIVE} ${FILE_NAME}.${DATESTAMP}.${FILE_EXTENSION}
  echo
}

snapshot_dir () {
  # This is for snapshoting a directory with a current DATESTAMP
  # DATESTAMP should no longer be unset as part of this function, bu I have not tested this yet.
  DATESTAMP=`datestamp`
  DIR_TO_ARCHIVE="`strip_trailing_slash $1`"
  cp -R -v ${DIR_TO_ARCHIVE} ${DIR_TO_ARCHIVE}.${DATESTAMP}
  echo
}
