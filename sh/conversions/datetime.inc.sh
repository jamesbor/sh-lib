convert_datetime_epoch_touch()
{
    # This function takes one argument which is the UNIX epoch time and returns it
    # in the format required for setting the datestamp mtime on a file with touch.
    test_number_args 1 "$@"				|| return $?
    gawk "BEGIN { print strftime(\"%G%m%d%H%M.%S\", ${1} ); }"
}

convert_datetime_epoch_human()
{
    # This function takes one argument which is the UNIX epoch time and returns it
    # in the format required for setting the datestamp mtime on a file with touch.
    test_number_args 1 "$@"				|| return $?
    gawk "BEGIN { print strftime(\"%+\", ${1} ); }"
}
