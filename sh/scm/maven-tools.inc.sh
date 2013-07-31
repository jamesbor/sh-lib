################################################################################
scm_maven_get_version()
{
    # This function takes one argument that is the maven POM file, and returns
    # the value from the 'version' field.
    test_number_args "1" $@					|| return $?
    local POM_FILE="${1}"
    test_file_good_for_read "${POM_FILE}"			|| return $?
    if (head -20 "${POM_FILE}" | tail -17 | awk -F'</?version>' 'NF>1{print $2}')
    then
        return 0
    else
        echo " There was a problem extracting the version from the pom."
        return 70
    fi
    echo " You should never see this, if you do there are some serious problems!"
}

################################################################################
test_scm_maven_snapshot()
{
    # This function takes one argument that is the version string from a
    # Maven POM file.  It will return success '0' if it is a SNAPSHOT and
    # '1' of it is not.  Use the scm_maven_get_version function to get the ver.
    test_number_args "1" $@					|| return $?
    local POM_VERSION="${1}"
    if (echo "${POM_VERSION}" | grep '\-SNAPSHOT$')>/dev/null
    then
        # We have a snapshot
        return 0
    else
        # We have a normal version
        return 1
    fi
    echo " You should never see this, if you do there are some serious problems!"
}
