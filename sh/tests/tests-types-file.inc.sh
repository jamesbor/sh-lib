test_file_contains_string()
{
    local FILE_TO_TEST="${1}"
    local STRING_TO_CHECK="${2}"
    if (grep "${STRING_TO_CHECK}" "${FILE_TO_TEST}" >/dev/null 2>/dev/null)
    then
        return 0
    else
        return 1
    fi
}
