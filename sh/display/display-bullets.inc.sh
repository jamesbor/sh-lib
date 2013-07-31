# This function takes a set of args and will list them all on new lines
# prefixed with ' - ' as bullets, if you want to change the bullet char
# then look at the functions available from the non core include files.
bullet_list_items() {
  # This function lists a given set of args, prefixed with the first arg
  PREFIX_BULLET="${1}"
  shift
  for ARG_TO_LIST in $@
  do
    echo "  ${PREFIX_BULLET} ${ARG_TO_LIST}"
  done
}

bullet_list_item() {
  # This function is for producing individual list items prefixed with the first
  PREFIX_BULLET="${1}"
  shift
  echo "  ${PREFIX_BULLET} $@"
}
