testVariableExists()
{
    test_variable_exists "$@"
}

test_variable_exists()
{
    local VARIABLE_NAME="${1}"
    #if [ "`eval echo \\${#${VARIABLE_NAME}[@]}`" -eq "0" ]
    if ! [ "`eval echo \\${${VARIABLE_NAME}+exists}`"  ]
    then
        # We have no variable with that name
        return 50
    else
        # The variable must exist!
        return 0
    fi
}

test_variable_set()
{
    local VARIABLE_NAME="${1}"
    if [ "`eval echo \\${#${VARIABLE_NAME}[@]}`" -eq "0" ]
    then
        # We have no values for that variable
        return 51
    else
        # The variable must exist!
        return 0
    fi
}

testVarableSet()
{
    # This test is for the shell test of 'Non Zero' size varable data
    local VARIABLE_NAME="${1}"
    if [ -n "`eval echo \\${${VARIABLE_NAME}}`" ]
    then
        # The variable must not exist or be of zero length
        return 0
    else
        # We have a non zero value for that variable
        return 52
    fi
}

testVarableEmpty()
{
    local VARIABLE_NAME="${1}"
    if [ -z "`eval echo \\${${VARIABLE_NAME}}`" ]
    then
        # The variable must not exist or be of zero length
        return 0
    else
        # We have a non zero value for that variable
        return 53
    fi
}

#testVarable()
#{
#    # This should work but does not on a mac anyway, it should check if a varable is set by name
#    local VARIABLE_NAME="${1}"
#    if [ -v "`eval echo \\${#${VARIABLE_NAME}[@]}`" ]
#    then
#        # We have a non zero value for that variable
#        return 54
#    else
#        # The variable must not exist or be of zero length
#        return 0
#    fi
#}
testVariableNameValid()
{
    local VARIABLE_NAME="${1}"
    if (testStringMatches '^[a-zA-Z_]+[a-zA-Z0-9_]*$' "${VARIABLE_NAME}")
    then
        # The variable must be valid
        return 0
    else
        # The variable name is invalid in some way
        return 54
    fi
}
