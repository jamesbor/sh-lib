list_http_clean_extra_data () {
  # Strip the extra HTML data from a list on an Apache server filesystem list
  while read DATA_TO_PROCESS
  do
    echo ${DATA_TO_PROCESS} 	|	# echo the data
	sed 's/.*href=\"//g'	|	# Strip off the start of the lines up to href="
        cut -d\" -f1		|	# Cut the string with " as a delimiter and get the first field
	strip_trailing_slash
  done
}

list_http_children() {
  # List the children on a std Apache filesystem list
  PATH_TO_PROCESS="`ensure_trailing_slash ${1}`"
  curl -s ${PATH_TO_PROCESS}	|	# Get the raw HTML
	grep '<tr>'		|	# get the '<tr>' lines
	grep 'href'			# get the 'href' lines
}

list_http_children_dirs() {
  # List the children that are DIR's on a std Apache filesystem list
  PATH_TO_PROCESS="`ensure_trailing_slash ${1}`"
  list_children ${PATH_TO_PROCESS}	|	# Get the raw HTML
	grep 'DIR'			|	# get the 'DIR' lines
	list_clean_extra_data		|	# clean any extra HTML data
	grep -v '^/'
}

list_http_children_not_dirs() {
  # List the children that are NOT DIR's on a std Apache filesystem list
  PATH_TO_PROCESS="${1}"
  list_children ${PATH_TO_PROCESS}	|	# Get the raw HTML
	grep -v 'DIR'			|	# get anything but the 'DIR' lines
	list_clean_extra_data		|	# clean any extra HTML data
	grep -v '^?'				# strip off any lines that start with a '?'
}
