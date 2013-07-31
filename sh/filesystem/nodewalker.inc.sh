fs_tree_start()
{
    echo "."
}

fs_tree_down()
{
    echo -n "│"
}

fs_tree_endnode()
{
    echo -n "└"
}

fs_tree_node()
{
    echo -n "└"
}

fs_tree_branchnode()
{
    echo -n "├"
}

fs_tree_branch()
{
    echo -n "─"
}

fs_node_process()
{
    test_number_args "4" "$@"				|| return $?
    local NODE="${1}"
    local NODE_PATH="${2}"
    local NODE_DEPTH="${3}"
    local NODES_MOREboolean="${4}"
    local BRANCH_LENGTH_PER_NODE=3

    # Lets give ourselves an indent
    (while [ "${NODE_DEPTH}" -gt "0" ]
    do
        for i in `seq ${BRANCH_LENGTH_PER_NODE}`
        do
            #fs_tree_branch
            echo -n " "
        done
        NODE_DEPTH=$((NODE_DEPTH - BRANCH_LENGTH_PER_NODE))
    done)

    # Okay, now lets parse the last char of the NODE and see what it is.
    case "${NODE: -1}" in
    /)
        # I am a directory
        #echo "|-${NODE_PATH}/${NODE} is a directory"
        NODE_DEPTH=$((NODE_DEPTH + 2))
        NODE="${NODE%/}"
        if [ "${NODES_MOREboolean}" == "false" ]
        then
            echo "`fs_tree_endnode; fs_tree_branch`${NODE} (directory)"
        else
            echo "`fs_tree_branchnode; fs_tree_branch`${NODE} (directory)"
        fi
        fs_nodewalker "${NODE_PATH}/${NODE}" "${NODE_DEPTH}"
        ;;
    \*)
        # I am executeable
        NODE_DEPTH=$((NODE_DEPTH + 2))
        NODE="${NODE%\*}"
        echo "${NODE} (executeable)"
        ;;
    @)
        # I am a symbolic link
        NODE_DEPTH=$((NODE_DEPTH + 2))
        NODE="${NODE%@}"
        echo "${NODE} (link)"
        ;;
    =)
        # I am a socket
        NODE_DEPTH=$((NODE_DEPTH + 2))
        NODE="${NODE%=}"
        echo "${NODE} (socket)"
        ;;
    \|)
        # I am a FIFO file
        NODE_DEPTH=$((NODE_DEPTH + 2))
        echo "${NODE} is a fifo file"
        ;;
    %)
        # I am a union
        NODE_DEPTH=$((NODE_DEPTH + 2))
        echo "${NODE} is a union"
        ;;
    *)
        # I am a normal file
        NODE_DEPTH=$((NODE_DEPTH + 2))
        if [ "${NODES_MOREboolean}" == "false" ]
        then
            echo "`fs_tree_endnode; fs_tree_branch`${NODE} (file)"
        else
            echo "`fs_tree_branchnode; fs_tree_branch`${NODE} (file)"
        fi
        ;;
    esac  
}

fs_nodewalker() 
{
    test_number_args "1|2" "$@"				|| return $?
    if (test_arg_exists "-\?|" "$@")
    then
        echo "usage: $0 ([-?] | [--help] | [VARIABLE NAME]) [RUN TYPE]"
        echo
        return 10
    elif (test_arg_exists "--help" "$@")
    then
        echo
        echo " Filesystem Node Walker:"
        echo " -----------------------"
        echo " usage: $0 [-?] | [--help] | [FILESYSTEM NODE]"
        echo
        echo " Help Options:"
        echo " [-?] | [--help]  usage or this detailed help screen"
        echo " [VARIABLE NAME]   general query for consumption by a human"
        echo " - value      To return the value of the variable/function"
        echo " - detail     To return all detail for computer consumption with the following columns:"
        echo -e "[TYPE FLAG]\t[TYPE HUMAN]\t[SET TO EXPORT]\t[SET READ ONLY]\t[FUNCTION?]"
        return 10
    fi
    # ARG1: FS_NODE_POINT
    local FS_NODE_POINT="${1}"
    local CHILD_NODES="`ls -1 -F ${FS_NODE_POINT}/`"
    #local NODES_MOREboolean="${3}"
    local -i NODES_LEFT="`echo "${CHILD_NODES}" | wc -l`"
    local -i DEPTH
    if [ -z "${2}" ]
    then
        # This is our first run, so lets start off the tree:
        fs_tree_start
        DEPTH=0
    else
        DEPTH="${2}"
    fi
    echo "${CHILD_NODES}" | while read NODE
    do
        NODES_LEFT=$((NODES_LEFT - 1))
        if [ "${NODES_LEFT}" -gt "0" ]
        then
            NODES_MOREboolean="true"
        else
            NODES_MOREboolean="false"
        fi
        #fs_node_process "${NODE}${NODES_LEFT}" "${FS_NODE_POINT}" "${DEPTH}" "${NODES_MOREboolean}"
        fs_node_process "${NODE}" "${FS_NODE_POINT}" "${DEPTH}" "${NODES_MOREboolean}"
    done
}
