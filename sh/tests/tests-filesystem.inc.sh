################################################################################
# Tests on files (and directorys, and pipes, and symbolic links, etc...) "-)
################################################################################
# State Tests
################################################################################
test_file_exists() 
{
    test_number_args 1 "$@"					|| return $?
    local FILE_TO_TEST="${1}"
    local -i TEST_ERROR_CODE="100"
    if [ -e "${FILE_TO_TEST}" ]
    then
        # File exists
        return 0
    else
        # File does not exist
        debugecho "[${TEST_ERROR_CODE}]: File: ${FILE_TO_TEST} does not exist."
        return ${TEST_ERROR_CODE}
    fi
}

################################################################################
test_file_has_a_execute_permission() 
{
    # REMEMBER!: A Directory that you can enter is executeable returns true!
    test_number_args 1 "$@" 					|| return $?
    local FILE_TO_TEST="${1}"
    local -i TEST_ERROR_CODE="101"
    if [ -x "${FILE_TO_TEST}" ]
    then
        # File exists and is executable
        return 0
    else
        # File does not exist
        debugecho "[${TEST_ERROR_CODE}]: File: ${FILE_TO_TEST} does not exist."
        return ${TEST_ERROR_CODE}
    fi
}

################################################################################
test_file_has_a_read_permission() 
{
    test_number_args 1 "$@" 					|| return $?
    local FILE_TO_TEST="${1}"
    local -i TEST_ERROR_CODE="102"
    if [ -r "${FILE_TO_TEST}" ]
    then
        # File exists and is readable
        return 0
    else
        # File is not readable or does not exist
        debugecho "[${TEST_ERROR_CODE}]: File: ${FILE_TO_TEST} is not readable or does not exist."
        return ${TEST_ERROR_CODE}
    fi
}

################################################################################
test_file_has_a_write_permission() 
{
    test_number_args 1 "$@" 					|| return $?
    local FILE_TO_TEST="${1}"
    local -i TEST_ERROR_CODE="103"
    if [ -w "${FILE_TO_TEST}" ]
    then
        # File or Directory is writeable and exists
        return 0
    else
        # File or Directory is not writable or does not exist
        debugecho "[${TEST_ERROR_CODE}]: File or Directory: ${FILE_TO_TEST} is not writeable or does not exist."
        return ${TEST_ERROR_CODE}
    fi
}

################################################################################
test_file_has_a_sticky_bit_set() 
{
    test_number_args 1 "$@" 					|| return $?
    local FILE_TO_TEST="${1}"
    local -i TEST_ERROR_CODE="105"
    if [ -k "${FILE_TO_TEST}" ]
    then
        # File has sticky bit set and exists
        return 0
    else
        # File does not have a sticky bit or does not exist
        debugecho "[${TEST_ERROR_CODE}]: File: ${FILE_TO_TEST} does not have a sitcky bit set or does not exist."
        return ${TEST_ERROR_CODE}
    fi
}

################################################################################
test_file_has_a_suid_flag() 
{
    # Test if set-group-id (sgid) flag set on file or directory
    # A binary owned by root with set-user-id flag set runs with root privileges, even when an ordinary user invokes it.
    # This is useful for executables (such as pppd and cdrecord) that need to access system hardware.
    # Lacking the suid flag, these binaries could not be invoked by a non-root user.
    # A file with the suid flag set shows an s in its permissions.
    test_number_args 1 "$@" 					|| return $?
    local FILE_TO_TEST="${1}"
    local -i TEST_ERROR_CODE="106"
    if [ -u "${FILE_TO_TEST}" ]
    then
        # File has set-uid flag set and exists
        return 0
    else
        # File does not have set-uid flag set or does not exist
        debugecho "[${TEST_ERROR_CODE}]: File: ${FILE_TO_TEST} does not have set-user-id flag set or does not exist."
        return ${TEST_ERROR_CODE}
    fi
}

################################################################################
test_file_has_not_been_modified_since_last_read() 
{
    test_number_args 1 "$@" 					|| return $?
    local FILE_TO_TEST="${1}"
    local -i TEST_ERROR_CODE="107"
    if [ -N "${FILE_TO_TEST}" ]
    then
        # File has not been modified since last read
        return 0
    else
        # File has been modified since last read
        debugecho "[${TEST_ERROR_CODE}]: File: ${FILE_TO_TEST} has been modified since last read.."
        return ${TEST_ERROR_CODE}
    fi
}

################################################################################
test_file_has_same_owner_as_this_process() 
{
    test_number_args 1 "$@" 					|| return $?
    local FILE_TO_TEST="${1}"
    local -i TEST_ERROR_CODE="108"
    if [ -O "${FILE_TO_TEST}" ]
    then
        # File has the same owner as this process and exists
        return 0
    else
        # File does not have the same owner as this process or does not exist
        debugecho "[${TEST_ERROR_CODE}]: File: ${FILE_TO_TEST} does not have the same owner as this process or does not exist."
        return ${TEST_ERROR_CODE}
    fi
}

################################################################################
test_directory_has_a_sgid_flag() 
{
    # Test if set-group-id (sgid) flag set on file or directory
    test_number_args 1 "$@" 					|| return $?
    local FILE_TO_TEST="${1}"
    local -i TEST_ERROR_CODE="109"
    if [ -g "${FILE_TO_TEST}" ]
    then
        # Directory (or file) has a set-group-id flag set and exists
        return 0
    else
        # Directory (or file) does not have a set-group-id set or does not exist
        debugecho "[${TEST_ERROR_CODE}]: Directory or File: ${FILE_TO_TEST} does not have set-group-id flag set or does not exist."
        return ${TEST_ERROR_CODE}
    fi
}

################################################################################
# Type Tests
################################################################################
test_file_is_not_empty() 
{
    test_number_args 1 "$@" 					|| return $?
    local FILE_TO_TEST="${1}"
    local -i TEST_ERROR_CODE="110"
    if [ -s "${FILE_TO_TEST}" ]
    then
        # File is not empty and exists
        return 0
    else
        # File is empty or does not exist
        debugecho "[${TEST_ERROR_CODE}]: File: ${FILE_TO_TEST} is empty or does not exist."
        return ${TEST_ERROR_CODE}
    fi
}

################################################################################
test_file_is_a_symbolic_link() 
{
    test_number_args 1 "$@" 					|| return $?
    local FILE_TO_TEST="${1}"
    local -i TEST_ERROR_CODE="111"
    # The -h test should do this too, but -L is more logical
    if [ -L "${FILE_TO_TEST}" ]
    then
        # File is a symbolic link and exists
        return 0
    else
        # File is not a symbolic link or does not exist
        debugecho "[${TEST_ERROR_CODE}]: File: ${FILE_TO_TEST} is not a symbolic link or does not exist."
        return ${TEST_ERROR_CODE}
    fi
}

################################################################################
test_file_is_a_block_device() 
{
    test_number_args 1 "$@" 					|| return $?
    local FILE_TO_TEST="${1}"
    local -i TEST_ERROR_CODE="112"
    if [ -b "${FILE_TO_TEST}" ]
    then
        # File is a block device and exists
        return 0
    else
        # File is not a block device or does not exist
        debugecho "[${TEST_ERROR_CODE}]: File: ${FILE_TO_TEST} is not a block device or does not exist."
        return ${TEST_ERROR_CODE}
    fi
}

################################################################################
test_file_is_a_character_device() 
{
    test_number_args 1 "$@" 					|| return $?
    local FILE_TO_TEST="${1}"
    local -i TEST_ERROR_CODE="113"
    if [ -c "${FILE_TO_TEST}" ]
    then
        # File is a character device and exists
        return 0
    else
        # File is not a character device or does not exist
        debugecho "[${TEST_ERROR_CODE}]: File: ${FILE_TO_TEST} is not a character device or does not exist."
        return ${TEST_ERROR_CODE}
    fi
}

################################################################################
test_file_is_a_pipe() 
{
    test_number_args 1 "$@" 					|| return $?
    local FILE_TO_TEST="${1}"
    local -i TEST_ERROR_CODE="114"
    if [ -p "${FILE_TO_TEST}" ]
    then
        # File is a pipe and exists
        return 0
    else
        # File is not a pipe or does not exist
        debugecho "[${TEST_ERROR_CODE}]: File: ${FILE_TO_TEST} is not a pipe or does not exist."
        return ${TEST_ERROR_CODE}
    fi
}

################################################################################
test_file_is_a_socket() 
{
    test_number_args 1 "$@" 					|| return $?
    local FILE_TO_TEST="${1}"
    local -i TEST_ERROR_CODE="115"
    if [ -S "${FILE_TO_TEST}" ]
    then
        # File is a socket and exists
        return 0
    else
        # File is not a socket or does not exist
        debugecho "[${TEST_ERROR_CODE}]: File: ${FILE_TO_TEST} is not a socket or does not exist."
        return ${TEST_ERROR_CODE}
    fi
}

################################################################################
test_file_is_a_terminal_device() 
{
    # Can also be used to check if STDIN or STDOUT is a terminal, e.g.
    # stdin [ -t 0 ] or stdout [ -t 1 ]
    test_number_args 1 "$@" 					|| return $?
    local FILE_TO_TEST="${1}"
    local -i TEST_ERROR_CODE="116"
    if [ -t "${FILE_TO_TEST}" ]
    then
        # File is a terminal device and exists
        return 0
    else
        # File is not a terminal device or does not exist
        debugecho "[${TEST_ERROR_CODE}]: File: ${FILE_TO_TEST} is not a terminal device or does not exist."
        return ${TEST_ERROR_CODE}
    fi
}

################################################################################
# Prior To Use Tests - Use these whenever you want to access a file in a script
################################################################################
test_file_good_for_read() 
{
    test_number_args 1 "$@" 					|| return $?
    local FILE_TO_TEST="${1}"
    local -i TEST_ERROR_CODE="120"
    test_file_exists "${FILE_TO_TEST}"				|| return $?
    test_file_has_a_read_permission "${FILE_TO_TEST}"		|| return $?
    test_file_is_not_empty "${FILE_TO_TEST}"			|| return $?
    test_is_a_file "${FILE_TO_TEST}"				|| return $?
    return 0
}

test_file_good_for_write() 
{
    test_number_args 1 "$@" 					|| return $?
    local FILE_TO_TEST="${1}"
    local -i TEST_ERROR_CODE="121"
    test_file_exists "${FILE_TO_TEST}"				|| return $?
    test_file_has_a_write_permission "${FILE_TO_TEST}"		|| return $?
    test_is_a_file "${FILE_TO_TEST}"				|| return $?
    return 0
}

test_file_good() 
{
    test_number_args 1 "$@" 					|| return $?
    local FILE_TO_TEST="${1}"
    test_file_exists "${FILE_TO_TEST}"				|| return $?
    test_is_a_file "${FILE_TO_TEST}"				|| return $?
    return 0
}

test_potential_file_good_for_write() 
{
    test_number_args 1 "$@" 					|| return $?
    local FILE_TO_TEST="${1}"
    local CONTAINING_DIRECTORY="`dirname ${1}`"
    local -i TEST_ERROR_CODE="122"
    test_is_a_directory "${CONTAINING_DIRECTORY}"		|| return $?
    test_file_has_a_write_permission "${CONTAINING_DIRECTORY}"	|| return $?
    return 0
}

test_potential_directory_good_for_write() 
{
    # The same as test_potential_file_good_for_write for now, but incase it
    # changes it is here as a placeholder so that we can use the correct
    # tests in our code.
    test_number_args 1 "$@" 					|| return $?
    local FILE_TO_TEST="${1}"
    local CONTAINING_DIRECTORY="`dirname ${1}`"
    #local -i TEST_ERROR_CODE="122" # Uncoment if we ever use this to do
        # its own tests
    test_is_a_directory "${CONTAINING_DIRECTORY}"		|| return $?
    test_file_has_a_write_permission "${CONTAINING_DIRECTORY}"	|| return $?
    return 0
}

test_directory_good_for_read() 
{
    test_number_args 1 "$@" 					|| return $?
    local FILE_TO_TEST="${1}"
    #local -i TEST_ERROR_CODE="125"
    test_is_a_directory "${FILE_TO_TEST}"			|| return $?
    test_file_has_a_read_permission "${FILE_TO_TEST}"		|| return $?
}

test_directory_good_for_write() {
    test_number_args 1 "$@" 					|| return $?
    local FILE_TO_TEST="${1}"
    #local -i TEST_ERROR_CODE="126"
    test_is_a_directory "${FILE_TO_TEST}"			|| return $?
    test_file_has_a_write_permission "${FILE_TO_TEST}"		|| return $?
}

################################################################################
# Is A Tests
################################################################################
test_is_a_directory() 
{
    test_number_args 1 "$@" 					|| return $?
    local FILE_TO_TEST="${1}"
    local -i TEST_ERROR_CODE="125"
    if [ -d "${FILE_TO_TEST}" ]
    then
        # Is a directory and exists
        return 0
    else
        # Is not a directory or does not exist
        debugecho "[${TEST_ERROR_CODE}]: Directory: ${FILE_TO_TEST} is not a valid directory or does not exist."
        return ${TEST_ERROR_CODE}
    fi
}

################################################################################
test_is_a_file() 
{
    test_number_args 1 "$@" 					|| return $?
    local FILE_TO_TEST="${1}"
    local -i TEST_ERROR_CODE="126"
    if [ -f "${FILE_TO_TEST}" ]
    then
        # Is a file
        return 0
    else
        # Is not a file
        debugecho "[${TEST_ERROR_CODE}]: File: ${FILE_TO_TEST} is not a regular file."
        return ${TEST_ERROR_CODE}
    fi
}

################################################################################
# Comparison Tests - Tests comparing two files
################################################################################
test_file_newer_than_file() 
{
    test_number_args 2 "$@" 					|| return $?
    local FILE1_TO_TEST="${1}"
    local FILE2_TO_TEST="${2}"
    local -i TEST_ERROR_CODE="130"
    if [ "${FILE1_TO_TEST}" -nt "${FILE2_TO_TEST}" ]
    then
        # File exists
        return 0
    else
        # File does not exist
        debugecho " File: ${FILE1_TO_TEST} does not exist or is not newer than: ${FILE2_TO_TEST}."
        return ${TEST_ERROR_CODE}
    fi 
}

################################################################################
test_file_older_than_file() 
{
    test_number_args 2 "$@" 					|| return $?
    local FILE1_TO_TEST="${1}"
    local FILE2_TO_TEST="${2}"
    local -i TEST_ERROR_CODE="131"
    if [ "${FILE1_TO_TEST}" -ot "${FILE2_TO_TEST}" ]
    then
        # File exists
        return 0
    else
        # File does not exist
        debugecho "[${TEST_ERROR_CODE}]: File: ${FILE1_TO_TEST} does not exist or is not older than: ${FILE2_TO_TEST}."
        return ${TEST_ERROR_CODE}
    fi
}

################################################################################
test_file_equivalent_to_file() 
{
    # i.e. are both hard links to the same file
    test_number_args 2 "$@" 					|| return $?
    local FILE1_TO_TEST="${1}"
    local FILE2_TO_TEST="${2}"
    local -i TEST_ERROR_CODE="132"
    if [ "${FILE1_TO_TEST}" -ef "${FILE2_TO_TEST}" ]
    then
        # File exists
        return 0
    else
        # File does not exist
        debugecho "[${TEST_ERROR_CODE}]: File: ${FILE1_TO_TEST} does not exist, or, is not either equivalent to, or a hard link to, the same place as: ${FILE2_TO_TEST}."
        return ${TEST_ERROR_CODE}
    fi
}
