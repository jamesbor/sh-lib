test_external_command()
{
    test_number_args "1" "$@"				|| return $?
    local THING_TO_TEST="${1}"
    if (which ${THING_TO_TEST} > /dev/null)
    then
        # We have the command availiable
        return 0
    else
        # We don't have the command availiable
        return 140
    fi
}
