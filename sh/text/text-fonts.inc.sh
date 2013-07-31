text_font_try()
{
    test_number_args "1" "$@"				|| return $?
    local TEXT_TO_TRY="${1}"
    if (test_external_command figlet)
    then 
        echo "Rendering with Figlet..."
    else 
        echo "The figlet utility is on on this system"
        return 240
    fi
    for i in `(cd fonts/ ; find . -name \*.flf | awk -F/ '{print $2}' | awk -F. '{print $1}')`
    do 
        figlet -d fonts -f $i -w 200 "1. Pre-Flight Checks"
    done
}
