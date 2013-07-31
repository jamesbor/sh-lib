type_int_pluralize()
{
    # This function is for pluralizing statements based on the value passed to it on ARG1
    test_number_args 1 "$@"				|| return $?
    if [ "${1}" -gt "1" ]
    then
        echo -n "s"
    fi
}
