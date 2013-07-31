fs_tree_simple()
{
    # This function will display a hierarchical tree, starting at the current directory or ARG1 
    # Use the following line if you want to take as a portable one liner that works in CWD.
    #ls -R | grep ":$" | sed -e 's/:$//' -e 's/[^-][^\/]*\//--/g' -e 's/^/   /' -e 's/-/|/'
    # N.B:  This will only display directorys, not files.
    ls -R ${1} | grep ":$" | sed -e 's/:$//' -e 's/[^-][^\/]*\//--/g' -e 's/^/   /' -e 's/-/|/'
}

fs_tree_simple_files()
{
    # This function will display a hierarchical tree, starting at the current directory or ARG1 
    # Use the following line if you want to take as a portable one liner that works in CWD.
    #  $  find . -print | sed -e '/^\.$/d' -e 's/[^-][^\/]*\//--/g' -e 's/^/   /' -e 's/-/|/'
    # N.B:  This will display directorys and files.
    find ${1} -print | sed -e '/^\.$/d' -e 's/[^-][^\/]*\//--/g' -e 's/^/   /' -e 's/-/|/'
}


