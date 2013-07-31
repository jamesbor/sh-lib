httpGetToStdout()
{
    # This will get ARG1 and display it on stdout
    curl 	--url		"${1}"					\
		--user-agent 	"sh-lib/1.0" 				\
		--referer 	"http://please.do-not.monitor-me.com/"
}

httpGetFormatedToStdout()
{
    # This will get ARG1 and display it on stdout
    curl 	--url		"${1}"					\
		--user-agent 	"sh-lib/1.0" 				\
		--referer 	"http://please.do-not.monitor-me.com/"  |
	xmllint --format -	# format for human consumption
}

httpGetToStdoutFollowRedirects()
{
    # Need to use - test_arg_exists or something to provide it as an arg
    # This will get ARG1 and display it on stdout
    curl 	--location	"${1}"					\
		--user-agent 	"sh-lib/1.0" 				\
		--referer 	"http://please.do-not.monitor-me.com/"
}

httpGetToFile()
{
    # This will get ARG1 and save it as ARG2
    curl 	--url		"${1}"					\
    		--user-agent 	"sh-lib/1.0"				\
		--referer 	"http://please.do-not.monitor-me.com/"	\
                --output	"${2}"
}

httpGetToFileRemoteName()
{
    # This will get ARG1 and save it as the remote filename as per the URL
    # passed to it, it will always be in the current working directory.
    # if you want it somewhere else., change to that directory first.
    curl 	--url		"${1}"					\
    		--user-agent 	"sh-lib/1.0"				\
		--referer 	"http://please.do-not.monitor-me.com/"	\
		--remote-name
}




