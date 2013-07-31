http_google_get()
{
    local QUERY_FOR_GOOGLE="`echo ${@} | sed 's/\ /+/g'`"	# Format the query for a URL
    local GOOGLE_URL="http://www.google.co.uk/search?q="
    curl --user-agent "Opera/9.80 (J2ME/MIDP; Opera Mini/4.2.14912/870; U; id) Presto/2.4.15" 	\
		-s "${GOOGLE_URL}${QUERY_FOR_GOOGLE}"
}


httpGetFormatedGoogleToStdout()
{
    local QUERY_FOR_GOOGLE="`echo ${@} | sed 's/\ /+/g'`"	# Format the query for a URL
    local GOOGLE_URL="http://www.google.co.uk/search?q="
    curl --user-agent "Opera/9.80 (J2ME/MIDP; Opera Mini/4.2.14912/870; U; id) Presto/2.4.15" 	\
	 -s "${GOOGLE_URL}${QUERY_FOR_GOOGLE}"							|
        xmllint --format -      # format for human consumption
}

