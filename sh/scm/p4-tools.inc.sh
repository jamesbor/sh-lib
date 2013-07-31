scm_p4_opened() 
{
    # Relies on p4 command line client.
    #p4 opened | awk 'BEGIN { FS = "#" } ; { print $1 }'
    test_number_args "0" "$@"                   	|| return $?
    p4 opened | cut -d# -f1
}

scm_p4_multirevert() 
{
  # Revert all files that are in 'opened' state
    test_number_args "0" "$@"                   	|| return $?
    for FILE in `scm_p4_opened`
    do
        echo "Reverting: ${FILE}"
        p4 revert ${FILE}
    done
}

scm_p4_multicheckin() 
{
    # Revert all files that are in 'opened' state
    test_number_args "1" "$@"                   	|| return $?
    for FILE in `find ${1}`
    do
        echo -n "P4 Edit: "
        p4 edit ${FILE}
    done
    p4 submit -d "James: Checking in all updated files in workspace"
}

scm_p4_ls()
{
    # This function takes a Perforce locaiton such as depot: //hcom/blahh/blahh
    # This locaiton is ensured to be followed with a trailing slash and is then appended with
    # a '*' so that it can be ls'd.  results then strip off the prefixing path that you have specified.
    test_number_args "1" "$@"                   	|| return $?
    local LOCATION_TO_LIST="`ensure_trailing_slash ${1}`"
    local LOCATION_TO_LIST_STRIP="`text_escape_forwardslash ${LOCATION_TO_LIST}`"
    p4 dirs "${LOCATION_TO_LIST}*" | sed "s/${LOCATION_TO_LIST_STRIP}//g"
}

scm_p4_changes_remote()
{
    test_number_args '^[01]$' "$@"			|| return $?
    local FILE_TO_QUERY="${1}"
    local SEARCH_PATH
    local ITEM_LIST
    local ITEM_TEST
    local EPOCH_SCM
    local EPOCH_LOCAL
    if [ "$#" -eq "0" ]
    then
        SEARCH_PATH=`pwd`
    elif  [ "$#" -eq "1" ]
    then
        SEARCH_PATH="`realpath ${1}`"
    fi
    ITEM_LIST="`find ${SEARCH_PATH} -type f`"
    for ITEM_TEST in ${ITEM_LIST}
    do
        EPOCH_SCM="`get_scm_p4_modtime_epoch ${ITEM_TEST}`"
        EPOCH_LOCAL="`get_file_modtime_epoch ${ITEM_TEST}`"
        if [ "${EPOCH_SCM}" -gt "${EPOCH_LOCAL}" ]
        then
            echo "${ITEM_TEST}"
        fi
    done
}

scm_p4_changes_local()
{
    test_number_args '^[01]$' "$@"			|| return $?
    local FILE_TO_QUERY="${1}"
    local SEARCH_PATH
    local ITEM_LIST
    local ITEM_TEST
    local EPOCH_SCM
    local EPOCH_LOCAL
    if [ "$#" -eq "0" ]
    then
        SEARCH_PATH=`pwd`
    elif  [ "$#" -eq "1" ]
    then
        SEARCH_PATH="`realpath ${1}`"
    fi
    ITEM_LIST="`find ${SEARCH_PATH} -type f`"
    for ITEM_TEST in ${ITEM_LIST}
    do
        EPOCH_SCM="`get_scm_p4_modtime_epoch ${ITEM_TEST}`"
        if [ "$?" -eq "230" ]
        then
            # We have a file that is not in SCM
            echo "${ITEM_TEST}  (new file)"
        else
            # We have a file that is in SCM, now lets check its freshness
            EPOCH_LOCAL="`get_file_modtime_epoch ${ITEM_TEST}`"
            if [ "${EPOCH_LOCAL}" -gt "${EPOCH_SCM}" ]
            then
                if (scm_p4_test_change "${ITEM_TEST}")
                then
                    echo "${ITEM_TEST}"
                else
                    echo "${ITEM_TEST}  (no changes, sync'd date/time)"
                    set_file_datetime_epoch "${ITEM_TEST}" "${EPOCH_SCM}"
                fi
            fi
        fi
    done
}

scm_p4_test_managedfile()
{
    # Use like: if (scm_p4_test_managedfile build_branch.sh); then echo is managed; else echo is not managed; fi
    test_number_args "1" "$@"				|| return $?
    local FILE_TO_QUERY="${1}"
    if (p4 filelog "${FILE_TO_QUERY}" 2>&1 | grep ' not on client.$' > /dev/null)
    then
        # The file is not SCM managed
        return 1
    else
        # The file is SCM managed
        return 0
    fi
}

scm_p4_changes_diff()
{
    test_number_args '^[01]$' "$@"			|| return $?
    local FILE_TO_QUERY="${1}"
    local SEARCH_PATH
    local ITEM_LIST
    local ITEM_TEST
    local EPOCH_SCM
    local EPOCH_LOCAL
    local PATH_STATE
    if [ "$#" -eq "0" ]
    then
        SEARCH_PATH=`pwd`
    elif  [ "$#" -eq "1" ]
    then
        SEARCH_PATH="`realpath ${1}`" 			|| return $?
    fi
    ITEM_LIST="`find ${SEARCH_PATH} -type f`"
    for ITEM_TEST in ${ITEM_LIST}
    do
        if (scm_p4_test_managedfile "${ITEM_TEST}")
        then 
            # We have a file that is in SCM, now lets check its freshness
            if ! (scm_p4_test_change "${ITEM_TEST}")
            then
                echo "${ITEM_TEST}"
            fi
        else
            echo "${ITEM_TEST} (new file)"
        fi
    done
}

scm_p4_test_change()
{
    # This funciton takes one argument that is a local file that is checked out.  It will compare
    # it to the equivelent file in perforce on the head.  If they are the same it returns 0, if not a 1
    test_number_args "1" "$@"                   	|| return $?
    local FILE_TO_TEST="${1}"
    test_file_good "${FILE_TO_TEST}"
    local FILE_STATE="$?"
    if [ "${FILE_STATE}" -eq "0" ]
    then
        local TMP_DIFF_FILE="`get_temporary_file scm-p4-diff`"
        p4 print "${FILE_TO_TEST}" | sed 1d > "${TMP_DIFF_FILE}"
        diff "${TMP_DIFF_FILE}" "${FILE_TO_TEST}" > /dev/null
        if [ "$?" -eq "1" ]
        then
            return 1
        else
            return 0
        fi
        rm -rf "${TMP_DIFF_FILE}"
    else
        return "${FILE_STATE}"
    fi
}

scm_p4_diff()
{
    # This funciton takes one argument that is a local file that is checked out.  It will compare
    # it to the equivelent file in perforce on the head and output a standard diff
    test_number_args "1" "$@"                   	|| return $?
    local FILE_TO_TEST="${1}"
    test_file_good "${FILE_TO_TEST}"
    local FILE_STATE="$?"
    if [ "${FILE_STATE}" -eq "0" ]
    then
        local TMP_DIFF_FILE="`get_temporary_file scm-p4-diff`"
        p4 print "${FILE_TO_TEST}" | sed 1d > "${TMP_DIFF_FILE}"
        diff "${TMP_DIFF_FILE}" "${FILE_TO_TEST}"
        if [ "$?" -eq "1" ]
        then
            return 1
        else
            return 0
        fi
        rm -rf "${TMP_DIFF_FILE}"
    else
        return "${FILE_STATE}"
    fi
}

scm_p4_clientspec_new()
{
    # This function creates the client spec for use accessing a Perforce repository
    # the client spec is output to STDOUT by default.
    local CLIENT_NAME="${1}"
    local FS_ROOT="${2}"
    
allwrite:noallwrite
clobber:noclobber
compress:nocompress
locked:unlocked
modtime:nomodtime
rmdir:normdir


submitunchangd
submitunchange+reopen
revertunchangd
revertunchange+reopen
leaveunchangd
leaveunchange+reopen

echo "Client: $CNAME" > /var/tmp/createclient.$CNAME
echo "Root: /var/tmp/${bamboo.AppName}/${bamboo.branchVersion}" >> /var/tmp/createclient.$CNAME
echo "Options: noallwrite noclobber normdir" >> /var/tmp/createclient.$CNAME
echo "SubmitOptions: submitunchanged" >> /var/tmp/createclient.$CNAME
echo "View:" >> /var/tmp/createclient.$CNAME
echo "     $PATHMain //$CNAME/..." >> /var/tmp/createclient.$CNAME
echo "     $PATHBranch //$CNAME/..." >> /var/tmp/createclient.$CNAME
}






scm_p4_client_create()
{
    # This function creates a Perforce client spec for use connecting to the CM repository
    # It is expected that the following environment varables are availiable: P4PORT, P4USER and P4PASSWD
    # the following are §
    local SCM_APP_NAME="${1}"
    local SCM_PROJECT_NAME="${2}"
    local SCM
# Create P4 Client to allow branch to be created. 

# Set-up variables
export P4PASSWD=${bamboo.repoPassword}
export P4PORT=${bamboo.p4Port}
export P4USER=${bamboo.p4User}
export CNAME=hcombuild-${bamboo.AppName}-${bamboo.branchVersion}-branch
export PATHMain=//hcom/${bamboo.Project_Name}/${bamboo.AppName}/Main/...
export PATHBranch=//hcom/${bamboo.Project_Name}/${bamboo.AppName}/Branches/...

# Set-up Workspace 
echo "Client: $CNAME" > /var/tmp/createclient.$CNAME
echo "Root: /var/tmp/${bamboo.AppName}/${bamboo.branchVersion}" >> /var/tmp/createclient.$CNAME
echo "Options: noallwrite noclobber normdir" >> /var/tmp/createclient.$CNAME
echo "SubmitOptions: submitunchanged" >> /var/tmp/createclient.$CNAME
echo "View:" >> /var/tmp/createclient.$CNAME
echo "     $PATHMain //$CNAME/..." >> /var/tmp/createclient.$CNAME
echo "     $PATHBranch //$CNAME/..." >> /var/tmp/createclient.$CNAME

# Create Workspace
/usr/bin/p4 client -i -t $CNAME < /var/tmp/createclient.$CNAME
}

get_scm_p4_modtime_epoch()
{
    test_number_args 1 "$@"				|| return $?
    local FILE_TO_QUERY="${1}"
    local COMMAND_OUTPUT
    COMMAND_OUTPUT=`p4 fstat "${FILE_TO_QUERY}" 2>&1`
    if (echo "${COMMAND_OUTPUT}" | grep ' - no such file(s).$' > /dev/null)
    then
        # The file is not in Perforce
        return 230
    else
        echo "${COMMAND_OUTPUT}" | grep headTime | awk '{print $3}'
    fi
}

