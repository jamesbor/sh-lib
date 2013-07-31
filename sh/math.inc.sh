count_arguments()
{
    # This funciotn is used as follows:
    #  $ count_arguments "$@" to pass the arguments of the calling script to the child function
    # It should return a number that is the ammount of individual arguments passed to the function
    echo "$#" 
}
